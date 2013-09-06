require 'pavlov/operation_finder'

module Pavlov
  class Backend
    attr_reader :pavlov_options

    def initialize(options = {})
      @pavlov_options = options.fetch(:pavlov_options, {})
    end

    def interactor(name, attributes = {})
      find_operation(::Interactors, name).new(with_pavlov_options(attributes)).call
    end

    def query(name, attributes = {})
      find_operation(::Queries, name).new(with_pavlov_options(attributes)).call
    end

    def command(name, attributes = {})
      find_operation(::Commands, name).new(with_pavlov_options(attributes)).call
    end

    private

    def find_operation(namespace, name)
      OperationFinder.find(namespace, name)
    end

    def with_pavlov_options hash
      if pavlov_options != {}
        if hash.key? 'pavlov_options'
          hash[:pavlov_options] = pavlov_options.merge(hash[:pavlov_options])
        else
          hash[:pavlov_options] = pavlov_options
        end
      end
      hash[:backend] = self
      hash
    end

  end
end
