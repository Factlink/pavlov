pavlov
======

Gem that provides infrastructure for ruby.
# Pavlov entities
What is done:

```ruby
class User < Pavlov::Entity do
  attributes :name, :username, :email
end

my_entitiy = User.create do
  self.name = 'jan'
  self.username = 'jjoos'
  self.email = 'jan@deelstra.org'
end

my_entity = my_entity.update do
  self.name = 'joop'
  self.email = 'joop@deelstra.org'
end

puts my_entity.username
```

## Atomic create, update functions
## Immutable
What still needs to be done:
## Validation
After create/update call validate so an entity is always valid.
## Make validation compatible with rails
Make sure the binding and error messages are compatible with rails.
## Make it possible to mount interactors in the entity if they have a first argument that accepts the entity.
The need for a lot of the duplicated validation in these interactors dissapears 
## Make it possible to mount interactors in the class.
Make a logical place to find these interactors.

Given:

Rails only calls interactors, queries and commands are only called by Interactors.



How to do Authorization in Pavlov:

There are multiple facets to whether a user is authorized:

1. Can this user execute this operation
2. On which set of objects can this user execute this operation

We decided that the best way to handle this is:

The interactors check whether an operation is authorized before running the execution code, but not in the initialization. This is not implemented yet, but will mean an interactor has something like run which does authorize; execute.

When a operation is executed on one object and this is not authorized, this is clearly an exceptional situation (in the sense that it shouldn't happen), and an exception is thrown.

When a operation is executed on a set of objects, the operation will only execute on the subset the user is authorized for.
