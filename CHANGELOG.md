# Pavlov Changelog

## 0.1.8.1

* Fixed regression in alpha_compatibility validation helper (validate_in_set)

## 0.1.8

* Added validations and an errors object. See the updated README for usage instructions.
* Changed the way operations are found. New way should be 100% compatible.

## 0.1.7.1

Fixed regressions in validation logic

## 0.1.7

* Removed the methods `old_interactor`, `old_command`, and `old_query` from both Pavlov module and Helpers.
* In preparation for changes to the validation system, we've changed the name of the method you should implement that performs the validations. This was `valid?`, and it is now `validate`. Like `execute`, this method should not be called directly, instead Pavlov provides a wrapper method called `valid?`. This allows us to add default validations without you having to remember to call `super`.

## 0.1.6

Fixed default argument for helpers with named arguments

Bugfixes and refactorings

Removed generators for commands, queries and interactors.

## 0.1.5

Made `Pavlov.old_command`, `old_query` and `old_interactor` use `Pavlov.command`, `Pavlov.query` and `Pavlov.interactor` so you can upgrade expectations in a forward compatible manner.

## 0.1.4

Added license to gemspec

Removed dependencies on activemodel and activesupport.

Deprecated Validations (now in alpha_compatibility)

## 0.1.3

This release brings forth lots and lots of incompatibilities. Where possible, we've tried to keep a backwards-compatible API available. You can activate this by requiring `pavlov/alpha_compatibility'.

#### New Stuff:

* Pavlov now uses Virtus for what used to be called `arguments`. Instead of specifying a list of arguments, you can now specify attributes individually, with optional defaults. Check the README on all the cool stuff you can do with these Virtus-based attributes.

#### Deprecations:

If you want to retain deprecated functionality, you can `require 'pavlov/alpha_compatibility'`.

* Deprecated `arguments` in operations.
* Deprecated `pavlov_options` that were used by the helpers.

#### Completely removed:

* Removed support for `finish_initialize`. Override the `initialize` method and call `super` instead.

## 0.1.2

Intermediate release easing upgrade to 0.1.3, please see https://github.com/Factlink/pavlov/blob/master/UPGRADING.md

## 0.1.1

Intermediate release easing upgrade to 0.1.3, please see https://github.com/Factlink/pavlov/blob/master/UPGRADING.md

## 0.1.0

Initial alpha-release. Here be dragons.
