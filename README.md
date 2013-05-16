# Pavlov [![Build Status](https://api.travis-ci.org/Factlink/pavlov.png)](http://travis-ci.org/Factlink/pavlov) [![Gem Version](https://badge.fury.io/rb/pavlov.png)](http://badge.fury.io/rb/pavlov) [![Dependency Status](https://gemnasium.com/Factlink/pavlov.png)](https://gemnasium.com/Factlink/pavlov) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/Factlink/pavlov)

The Pavlov gem provides a Command/Query/Interactor framework. In our usage, we
have found this to be a good solution for things that cut across multiple
domain models.  It allows you to keep your ActiveRecord models focussed on
their own table.  It also allows you to keep your controller actions short and
focussed. Anything beyond one or two lines could be turned into Command
objects, without the Fat Model problem.

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

#### Callbacks

Any operation can define a set of callbacks that will be executed.

```ruby
class InvitationsController < ApplicationController
  def send_email
    invitation = query :find_invitation, id: params[:id]
    command :send_invitation_by_email, invitation: invitation,
            on_success -> { flash[:success] = "Mail was sent!" },
            on_failure -> { flash[:failure] = "Could not send email :(" }
  end
end

class Commands::SendInvitationByEmail
  argument :invitation
  callback :success
  callback :failure

  def execute
    if rand > 0.5
      execute_callbacks_for :success
    else
      execute_callbacks_for :failure
    end
  end
end
```

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

When a operation is executed on a set of objects, the operation will only
execute on the subset the user is authorized for.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Run bundle, before starting development.
4. Implement your feature/bugfix and corresponding tests.
5. Make sure your tests run against the latest stable mri.
6. Commit your changes (`git commit -am 'Add some feature'`)
7. Push to the branch (`git push origin my-new-feature`)
8. Create new Pull Request
