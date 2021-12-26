# Users::API

The gem provides HTTP/json API to the [Users](__TODO__) gem, that was developed as a clean Users Domain by help of [Cleon](__TODO__).

The API is simple [Sinatrarb]() application that mainly consumes Users Domain services, at the same time providing persistence implementation of Users::Gateway for [PStore]() and [SQLite]() through [Sequel]() gem.

The [Users Domain]() implemented in the separate gem [Users] that it required through Gemfile.

TODO: The app is also provides logging layer? Or maybe it implemented at the level or Rack?

TODO:

- share gateway spec code between gateway all instances
- turn `Sequel::UniqueConstraintViolation` into general `Users::Error`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'users-api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install users-api

## Usage

Run the service

    bundle install  
    bundle exec rackup # -s thin -p 4567.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/users-api.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
