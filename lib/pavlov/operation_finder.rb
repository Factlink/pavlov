require 'pavlov/support/inflector'

module Pavlov
  class OperationFinder
    attr_reader :namespace

    def self.find(namespace, operation_name)
      operation_lookup_list = Inflector.camelize(operation_name.to_s).split('::')
      operation_lookup_list.reduce(namespace) do |current_namespace, namespace_or_operation_name|
        new(current_namespace).send(namespace_or_operation_name)
      end
    end

    def initialize(namespace)
      @namespace = namespace
    end

    def method_missing(name, attributes = {})
      _find_klass(name)
    end

    def respond_to_missing?(name, include_private = false)
      _find_klass(name)
    end

    private

    def _find_klass(name)
      namespace.const_get(Inflector.camelize(name.to_s))
    end
  end
end
