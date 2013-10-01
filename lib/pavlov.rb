require 'pavlov/support/inflector'

module Pavlov
  def self.command command_name, *args
    klass = class_for_command(command_name)
    operation = klass.new(*args)
    if block_given?
      yield operation
    else
      operation.call
    end
  end

  def self.interactor interactor_name, *args
    klass = class_for_interactor(interactor_name)
    operation = klass.new(*args)
    if block_given?
      yield operation
    else
      operation.call
    end
  end

  def self.query query_name, *args
    klass = class_for_query(query_name)
    operation = klass.new(*args)
    if block_given?
      yield operation
    else
      operation.call
    end
  end

  private

  def self.class_for_command command_name
    OperationFinder.find(Commands, command_name)
  end

  def self.class_for_interactor interactor_name
    OperationFinder.find(Interactors, interactor_name)
  end

  def self.class_for_query query_name
    OperationFinder.find(Queries, query_name)
  end
end

require_relative 'pavlov/engine' if defined?(Rails)
require_relative 'pavlov/operation_finder'
require_relative 'pavlov/helpers'
require_relative 'pavlov/access_denied'
require_relative 'pavlov/operation'
require_relative 'pavlov/command'
require_relative 'pavlov/query'
require_relative 'pavlov/interactor'
require_relative 'pavlov/version'
