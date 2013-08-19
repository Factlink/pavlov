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
    klass = class_for_command(command_name)
    klass.new(*args).call
  end

  def self.interactor interactor_name, *args
    klass = class_for_interactor(interactor_name)
    klass.new(*args).call
  end

  def self.query query_name, *args
    klass = class_for_query(query_name)
    klass.new(*args).call
  end

  private

  def self.class_for_command command_name
    class_name = 'Commands::' + string_to_classname(command_name)
    get_class_by_string(class_name)
  end

  def self.class_for_interactor interactor_name
    class_name = 'Interactors::' + string_to_classname(interactor_name)
    get_class_by_string(class_name)
  end

  def self.class_for_query query_name
    class_name = 'Queries::' + string_to_classname(query_name)
    get_class_by_string(class_name)
  end
end

require_relative 'pavlov/engine' if defined?(Rails)
require_relative 'pavlov/helpers'
require_relative 'pavlov/access_denied'
require_relative 'pavlov/backend'
require_relative 'pavlov/operation'
require_relative 'pavlov/command'
require_relative 'pavlov/query'
require_relative 'pavlov/interactor'
require_relative 'pavlov/version'
