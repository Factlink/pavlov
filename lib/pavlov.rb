module Pavlov
  # this method is also available as constantize in Rails,
  # but we want to be able to write classes and/or tests without Rails
  def self.get_class_by_string classname
    classname.constantize
  end

  def self.string_to_classname string
    string.to_s.camelize
  end
end

require_relative 'pavlov/engine' if defined?(Rails)
require_relative 'pavlov/helpers'
require_relative 'pavlov/access_denied'
require_relative 'pavlov/validation_error'
require_relative 'pavlov/validations'
require_relative 'pavlov/operation'
require_relative 'pavlov/command'
require_relative 'pavlov/query'
require_relative 'pavlov/interactor'
require_relative 'pavlov/version'
