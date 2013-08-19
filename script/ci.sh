#!/bin/bash

set -e

rake spec
bundle exec rubocop
