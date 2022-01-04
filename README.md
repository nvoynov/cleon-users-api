# UsersAPI

## TODO

- It seems that gateway for Cleon must be only one interface with no implementations. So check for creating folders for gateways - it must be removed.
- Where to place MemoryGateway for testing purpose, and maybe running the service with this gateway

## Overview

This demo gem gives an example how to develop an interface to the domain created by [Cleon](). It demonstrates the implementation of the HTTP/JSON API interface for the [Users Domain](). Sinatrarb plays for HTTP interaction and Sequel adapter for SQLite plays for the data storage layer.

To create a working interface for Cleon's domain, would it be API, UI, or CLI, besides the interface code itself, one needs to create ports for the domain services and implement the domain data gateway interface.

As one can see, the [Users Domain]() is implemented as the separate gem [Users Domain]() that it required through `gem "users", path: "../users"
` in Gemfile and `spec.add_dependency "users"` in .gemspec. Therefore installation process will be unusual a bit.

So you can see there in the `lib` folder

- `users_api.rb` - main module of the gem that mainly just require all sources
- `users_api/service.rb` - the http service
- `users_api/version.rb` - the gem version
- `users_api/gateway.rb` - the gateway implementation
- `users_api/ports.rb` - requiring all service ports
- `users_api/ports/service_port.rb` - service port basic class
- `users_api/ports/register_user_port.rb` - port for RegisterUser
- `users_api/ports/authenticate_user_port.rb` - etc...
- `users_api/ports/change_user_password_port.rb`
- `users_api/ports/select_users_port.rb`

## Installation

Execute:

    $ git clone https://github.com/nvoynov/cleon-users.git
    $ git clone https://github.com/nvoynov/cleon-users-api.git
    $ cd cleon-users-api
    $ bundle install

When you stuck for sqlite3, follow [installation instruction](https://github.com/sparklemotion/sqlite3-ruby).

## Usage

Run the service

    $ bundle exec rake test
    $ bundle exec rackup # -s thin -p 4567.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/users-api.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
