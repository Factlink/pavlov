## 0.1.3

* change all calls to the constructor of operations to construct with named parameters instead of positional parameters
* change all tests for authorization and validation, since those now get called when invoking `#call` instead of on initialization

## before 0.1.3

* change tests which expect invocations of validations to tests which check whether an error has been thrown when you give it invalid input.
* change tests where you check whether authorized? is called, to ones where you invoke the operation unauthorized, and check if an error is thrown.
* always call arguments, also when the operation has no arguments. Then just invoke arguments without any arguments.

## 0.1.2

* change all your specs/test to expect `old_command`, `old_query` and `old_interactor` instead of `command`, `query` and `interactor`

## before 0.1.2

* change all tests to expect `command`, `query` and `interactor` to be called on the module Pavlov, instead of on the object under test.

## 0.1.1

* Where you require pavlov, also require 'pavlov/alpha_compatibility'
* change all calls of `query`, `command` and `interactor` to `old_query`, `old_command`, `old_query`
* change all references to `@options` in interactors, commands and queries to `pavlov_options`

## 0.1.0

This guide assumes you're at least at 0.1.0
