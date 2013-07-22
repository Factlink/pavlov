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

Then generate some initial files with:

    rails generate pavlov:install

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

Interactors must define a method `authorized?` that determines if the interaction is allowed. If this method returns a truthy value, Pavlov will allow the interaction to be executed. This check is performed when `interaction.call` is executed.

To help you determine whether operations are allowed, you can set up a global [interaction context](#context), which you can then access from your interactors:

```ruby
class Interactors::CreateBlogPost
  include Pavlov::Interactor

  def authorized?
    context.current_user.is_admin?
  end
end
```

If the interaction is not authorized, a `Pavlov::AuthorizationError` exception will be thrown. In normal execution you wouldn't expect this to ever occur, so might be reasonable to set up a global catch for this exception that redirects users to your homepage:

```ruby
class ApplicationController
  rescue_from Pavlov::AuthorizationError, with: :possible_hack_attempt

  private

  def possible_hack_attempt
    logger.warn 'This might have been a hacker'
    redirect_to root_path
  end
end
```

### Context

You probably have certain aspects of your application that you always, or at least very often, want to pass into the interactors, so that they can check authorization, either in terms of blocking unauthorized executions, or automatically scoping queries so that e.g. users will only see data belonging to their account.

```ruby
class ApplicationController < ActionController::Base
  include Pavlov::Helpers

  before_filter :set_pavlov_context

  private

  def set_pavlov_context
    context.add(:current_user, current_user)
  end
end
```

In your tests, you could write:

```ruby
describe CreateBlogPost do
  include Pavlov::Helpers

  let(:user) { mock("User", is_admin?: true) }
  before { context.add(:current_user, user) }

  it 'should create posts' do
    interactor(:create_blog_post, title: 'Foo', body: 'Bar').call
    # test for the creation
  end
end
```

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
