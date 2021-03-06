require 'singleton'
require 'optparse'
require 'fileutils'
require 'logger'

$stdout.sync = true

module Canto
  class CLI
    include Singleton

    class << self
      attr_accessor :logger
    end

    attr_accessor :environment

    def parse(args = ARGV)
      initialize_logger
      setup_options(args)
      validate!
    end

    def run(boot_app: true)
      boot_application if boot_app

      self_read, self_write = IO.pipe
      sigs = %w[INT TERM TTIN TSTP]
      sigs.each do |sig|
        trap sig do
          self_write.puts(sig)
        end
      rescue ArgumentError
        puts "Signal #{sig} not supported"
      end

      launch(self_read)
    end

    def launch(self_read)
      begin
        while (readable_io = IO.select([self_read]))
          signal = readable_io.first[0].gets.strip
          handle_signal(signal)
        end
      rescue Interrupt
        CLI.logger.info 'Shutting down'
        CLI.logger.info 'Bye!'

        # Explicitly exit so busy Processor threads won't block process shutdown.
        #
        # NB: slow at_exit handlers will prevent a timely exit if they take
        # a while to run. If Sidekiq is getting here but the process isn't exiting,
        # use the TTIN signal to determine where things are stuck.
        exit(0)
      end
    end

    SIGNAL_HANDLERS = {
      # Ctrl-C in terminal
      'INT' => ->(_) { raise Interrupt },
      # TERM is the signal that Pipe must exit.
      # Heroku sends TERM and then waits 30 seconds for process to exit.
      'TERM' => ->(_) { raise Interrupt },
      'TSTP' => ->(_) {
        CLI.logger.info 'Received TSTP, no longer accepting new work'
      },
      'TTIN' => ->(_) {
        Thread.list.each do |thread|
          CLI.logger.warn "Thread TID-#{(thread.object_id ^ ::Process.pid).to_s(36)} #{thread.name}"
          if thread.backtrace
            CLI.logger.warn thread.backtrace.join("\n")
          else
            CLI.logger.warn '<no backtrace available>'
          end
        end
      }
    }
    UNHANDLED_SIGNAL_HANDLER = ->(_) { CLI.logger.info 'No signal handler registered, ignoring' }
    SIGNAL_HANDLERS.default = UNHANDLED_SIGNAL_HANDLER

    def handle_signal(sig)
      CLI.logger.debug "Got #{sig} signal"
      SIGNAL_HANDLERS[sig].call(self)
    end

    def options
      @options ||= Canto::DEFAULTS
    end

    def setup_options(args)
      # parse CLI options
      opts = parse_options(args)

      set_environment opts[:environment]

      options.merge!(opts)
    end

    def parse_options(argv)
      opts = {}
      @parser = option_parser(opts)
      @parser.parse!(argv)
      opts
    end

    alias_method :die, :exit

    def set_environment(cli_env)
      @environment = cli_env || ENV['APP_ENV'] || ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'
    end

    def initialize_logger
      CLI.logger = Logger.new($stdout, level: Logger::INFO)
    end

    def boot_application
      ENV['RACK_ENV'] = ENV['RAILS_ENV'] = environment

      require options[:require]
    end

    def validate!
      if !File.exist?(options[:require]) ||
          (File.directory?(options[:require]) && !File.exist?("#{options[:require]}/config/application.rb"))
        CLI.logger.info '=================================================================='
        CLI.logger.info '  Please point Canto to Ruby file  '
        CLI.logger.info '  to load your classes with -r [FILE].'
        CLI.logger.info '=================================================================='
        CLI.logger.info @parser
        die(1)
      end
    end

    def option_parser(opts)
      parser = OptionParser.new { |o|
        o.on '-e', '--environment ENV', 'Application environment' do |arg|
          opts[:environment] = arg
        end

        o.on '-r', '--require [PATH]', 'Location of ruby file to require' do |arg|
          opts[:require] = arg
        end

        o.on '-V', '--version', 'Print version and exit' do |arg|
          puts "Canto #{Canto::VERSION}"
          die(0)
        end
      }

      parser.banner = 'canto [options]'
      parser.on_tail '-h', '--help', 'Show help' do
        CLI.logger.info parser
        die 1
      end

      parser
    end
  end
end
