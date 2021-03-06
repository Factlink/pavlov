## HEAD

# 0.1.10

* Report more detailed error messages in exceptions about validation failures.

# 0.1.9

?

# 0.1.8

* Let custom validations use errors.add instead of raising exceptions
* Let your test check errors after calling valid, instead of checking whether calling call raises exceptions (we advise you wrap the old tests in a helper, before upgrading, so you only need to update your helper)

# 0.1.7.1

* Rename all your `valid?` methods to `validate`. If you called `valid?` on your operations, you can continue to do so.

## 0.1.7

Skip this version

## 0.1.6


## 0.1.5

* Change your expectations to expect `Pavlov.command` with hash arguments instead of `Pavlov.old_command` with positional arguments. Same for `query` and `interactor`
* Change all your invocations to call command with hash arguments instead of old_command. Same for `query` and `interactor`.

## 0.1.4

* If you use validations, you must now either use alpha_compatibility, or copy them to your own codebase.

## 0.1.3

* change all calls to the constructor of operations to construct with named parameters instead of positional parameters
* change all tests for authorization and validation, since those now get called when invoking `#call` instead of on initialization

## before 0.1.3

* change tests which expect invocations of validations to tests which check whether an error has been thrown when you give it invalid input.
* change tests where you check whether authorized? is called, to ones where you invoke the operation without any prior checks, and catch `Pavlov::AccessDenied` which is thrown when an operation is unauthorized.
* always call arguments, also when the operation has no arguments. Then just invoke `arguments` without any arguments.

## 0.1.2

* change all your specs/test to expect `old_command`, `old_query` and `old_interactor` instead of `command`, `query` and `interactor`

## before 0.1.2

* change all tests to expect `command`, `query` and `interactor` to be called on the module Pavlov, instead of on the object under test.

## 0.1.1

* Where you require pavlov, also 'pavlov/alpha_compatibility' instead
* change all calls of `query`, `command` and `interactor` to `old_query`, `old_command`, `old_query`
* change all references to `@options` in interactors, commands and queries to `pavlov_options`

## 0.1.0

This guide assumes you're at least at 0.1.0
