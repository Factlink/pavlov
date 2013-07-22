require 'active_support/inflector'

module Pavlov
  class Backend
    attr_reader :context

    def initialize(context = {})
      @context = context
    end

    def interactor(name, attributes = {})
      find_operation("Interactors", name).new(attributes.merge(backend: self))
    end

    def query(name, attributes = {})
      find_operation("Queries", name).new(attributes.merge(backend: self))
    end

    def command(name, attributes = {})
      find_operation("Commands", name).new(attributes.merge(backend: self))
    end

    private

    def find_operation(namespace, name)
      class_name = namespace + "::"+ name.to_s.camelize
      class_name.constantize
    end
  end
end
