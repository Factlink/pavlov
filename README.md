# Pavlov [![Build Status](https://api.travis-ci.org/Factlink/pavlov.png)](http://travis-ci.org/Factlink/pavlov) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/Factlink/pavlov)

Gem that provides infrastructure for ruby.

### Use at your own risk, this is _EXTREMELY_ alpha and subject to changes without notice.

## Installation

Add this line to your application's Gemfile:

    gem 'pavlov'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pavlov


## Commands, Queries and Interactors
Inspiration:
http://www.confreaks.com/videos/759-rubymidwest2011-keynote-architecture-the-lost-years
http://martinfowler.com/bliki/CQRS.html

Frontend only calls interactors. Interactors call queries and commands.
Queries never call commands, they can call queries.
Commands can call commands and queries.
But keep your design _simple_ (KISS).

### Usage

TODO

### Authorization

There are multiple facets to whether a user is authorized:

1. Can this user execute this operation
2. On which set of objects can this user execute this operation

We decided that the best way to handle this is:

The interactors check whether an operation is authorized before running the execution code, but not in the initialization. This is not implemented yet, but will mean an interactor has something like run which does authorize; execute.

When a operation is executed on one object and this is not authorized, this is clearly an exceptional situation (in the sense that it shouldn't happen), and an exception is thrown.

When a operation is executed on a set of objects, the operation will only execute on the subset the user is authorized for.

## Immutable objects
These objects can be used to simplify your design by making sure your object is always valid.
### Usage
```ruby
class User < Pavlov::Entity do
  attributes :name, :username, :email
end

my_entitiy = User.new do
  self.name = 'jan'
  self.username = 'jjoos'
  self.email = 'jan@deelstra.org'
end

or

my_entitiy = User.new({name: 'jan', username: 'jjoos', email: 'jan@deelstra.org'})

my_entity = my_entity.update({name: 'joop', email: 'joop@deelstra.org'})

puts my_entity.username
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Run bundle, before starting development.
4. Implement your feature/bugfix and corresponding tests.
5. Make sure your tests run against the latest stable mri.
6. Commit your changes (`git commit -am 'Add some feature'`)
7. Push to the branch (`git push origin my-new-feature`)
8. Create new Pull Request
