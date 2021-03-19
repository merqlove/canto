# Canto

[![CircleCI](https://circleci.com/gh/merqloveu/canto.svg?style=svg)](https://circleci.com/gh/merqloveu/canto)
[![Gem Version](https://badge.fury.io/rb/canto.svg)](https://badge.fury.io/rb/canto)

Canto is a tool to run plain non-blocking ruby programs, like pubsub.
Canto has simple IO.pipe interface, watching for signals, makes your non-blocking apps running.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'canto'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install canto

## Usage

    bundle exec canto -r PATH_TO_YOUR_RUBY_FILE -e production

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake test` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/merqlove/canto. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/merqloveu/canto/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Canto project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/merqloveu/canto/blob/master/CODE_OF_CONDUCT.md).
