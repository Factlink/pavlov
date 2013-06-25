module Pavlov
  # this method is also available as constantize in Rails,
  # but we want to be able to write classes and/or tests without Rails
  def self.get_class_by_string classname
    classname.constantize
  end

  def self.string_to_classname string
    string.to_s.camelize
  end

  def self.command command_name, *args
    class_name = "Commands::"+string_to_classname(command_name)
    klass = get_class_by_string(class_name)
    klass.new(*args).call
  end

  def self.interactor command_name, *args
    class_name = "Interactors::"+string_to_classname(command_name)
    klass = get_class_by_string class_name
    klass.new(*args).call
  end

  def self.query command_name, *args
    class_name = "Queries::"+string_to_classname(command_name)
    klass = get_class_by_string class_name
    klass.new(*args).call
  end
end

require_relative 'pavlov/version'

require_relative 'pavlov/engine' if defined?(Rails)

require_relative 'pavlov/helpers'
require_relative 'pavlov/operation'
require_relative 'pavlov/command'
require_relative 'pavlov/query'
require_relative 'pavlov/interactor'
