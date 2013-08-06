# Pavlov Changelog

## HEAD

Added version to gemspec

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
