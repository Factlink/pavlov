# Pavlov [![Build Status](https://api.travis-ci.org/Factlink/pavlov.png)](http://travis-ci.org/Factlink/pavlov) [![Gem Version](https://badge.fury.io/rb/pavlov.png)](http://badge.fury.io/rb/pavlov) [![Dependency Status](https://gemnasium.com/Factlink/pavlov.png)](https://gemnasium.com/Factlink/pavlov) [![Code Climate](https://codeclimate.com/github/Factlink/pavlov.png)](https://codeclimate.com/github/Factlink/pavlov) [![Coverage Status](https://coveralls.io/repos/Factlink/pavlov/badge.png?branch=master)](https://coveralls.io/r/Factlink/pavlov)

The Pavlov gem provides a Command/Query/Interactor framework. In our usage, we
have found this to be a good solution for things that cut across multiple
domain models.  It allows you to keep your ActiveRecord models focussed on
their own table.  It also allows you to keep your controller actions short and
focussed. Anything beyond one or two lines could be turned into Command
objects, without the Fat Model problem.

## Installation

Add this line to your application's Gemfile:

    gem 'pavlov'

## Usage

```ruby
class Commands::CreateBlogPost
  include Pavlov::Command

  attribute :id,        Integer
  attribute :title,     String
  attribute :body,      String
  attribute :published, Boolean

  private

  def validate
    errors.add(:id, "can't contain spaces") if id.include?(" ")
  end

  def execute
    $redis.hmset("blog_post:#{id}", title: title, body: body, published: published)
    $redis.sadd("blog_post_list", id)
  end
end

class Queries::AvailableId
  include Pavlov::Query

  private

  def execute
    generate_uuid
  end

  def generate_uuid
    SecureRandom.hex(64) # TODO Look up actual implementation
  end
end

class Interactors::CreateBlogPost
  include Pavlov::Interactor

  attribute :title,     String
  attribute :body,      String
  attribute :published, Boolean, default: true

  private

  def authorized?
    context.current_user.is_admin?
  end

  def validate
    errors.add(:body, "NO SHOUTING!!!!") if body.matches?(/\W[A-Z]{2,}\W/)
  end

  def execute
    command :create_blog_post, id: available_id,
                               title: title,
                               body: body,
                               published: published
    Struct.new(:title, :body).new(title, body)
  end

  def available_id
    query :available_id
  end
end

class PostsController < ApplicationController
  include Pavlov::Helpers

  respond_to :json

  def create
    interaction = interactor :create_blog_post, params[:post]

    if interaction.valid?
      respond_with interaction.call
    else
      respond_with {errors: interaction.errors}
    end
  rescue AuthorizationError
    flash[:error] = "Hacker, begone!"
    redirect_to root_path
  end
end
```

### Attributes

Attributes work mostly like Virtus does. Attributes are always required unless they have a default value.

### Validations

### Authorization

There are multiple facets to whether a user is authorized:

1. Can this user execute this operation
2. On which set of objects can this user execute this operation

We decided that the best way to handle this is:

The interactors check whether an operation is authorized before running the
execution code, but not in the initialization. This is not implemented yet, but
will mean an interactor has something like run which does authorize; execute.

When a operation is executed on one object and this is not authorized, this is
clearly an exceptional situation (in the sense that it shouldn't happen), and
an exception is thrown.

## Is it any good?

Yes.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Run bundle, before starting development.
4. Implement your feature/bugfix and corresponding tests.
5. Make sure your tests run against the latest stable mri.
6. Commit your changes (`git commit -am 'Add some feature'`)
7. Push to the branch (`git push origin my-new-feature`)
8. Create new Pull Request
