require 'pavlov/support/inflector'

module Pavlov
  def self.command command_name, *args, &block
    command = get_instance(Commands, command_name, *args)

    call_or_yield_instance command, &block
  end

  def self.interactor interactor_name, *args, &block
    interactor = get_instance(Interactors, interactor_name, *args)

    call_or_yield_instance interactor, &block
  end

  def self.query query_name, *args, &block
    query = get_instance(Queries, query_name, *args)

    call_or_yield_instance query, &block
  end

  private

  def self.get_instance(klass, name, *args)
    OperationFinder.find(klass, name).new(*args)
  end

  def self.call_or_yield_instance operation, &block
    if block.nil?
      operation.call
    else
      block.call operation
    end
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
