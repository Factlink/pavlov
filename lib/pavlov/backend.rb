require 'pavlov/operation_finder'

module Pavlov
  class Backend
    attr_reader :context

    def initialize(context = {})
      @context = context
    end

    def interactors
      OperationFinder.new("Interactors", self, false)
    end

    def queries
      OperationFinder.new("Queries", self, true)
    end

    def commands
      OperationFinder.new("Commands", self, true)
    end
  end
end
