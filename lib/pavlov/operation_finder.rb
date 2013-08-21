require 'pavlov/support/inflector'

module Pavlov
  class MethodOperation
    def initialize(klass, method)
      @klass  = klass
      @method = method
    end

    def new(attributes = {})
      @attributes = attributes
      self
    end

    def call
      @klass.public_send(@method, @attributes)
    end
  end

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
      find_method(name) || find_klass(name)
    end

    def respond_to_missing?(name, include_private = false)
      find_klass(name)
    end

    private

    def find_method(name)
      method_name = Inflector.underscore(name.to_s)
      if namespace.respond_to?(method_name)
        MethodOperation.new(namespace, method_name)
      end
    end

    def find_klass(name)
      namespace.const_get(Inflector.camelize(name.to_s), false)
    end
  end
end
