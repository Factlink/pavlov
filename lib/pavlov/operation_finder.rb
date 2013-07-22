module Pavlov
  class OperationFinder
    attr_reader :namespace, :backend

    def initialize(namespace, backend, autocall = false)
      @namespace = namespace
      @backend   = backend
      @autocall  = autocall
    end

    def method_missing(name, attributes = {})
      klass    = namespace.constantize.const_get(name.to_s.camelize)
      instance = klass.new(attributes.merge(backend: backend))

      if @autocall
        instance.call
      else
        instance
      end
    end

    def respond_to_missing?(name, include_private = false)
      _find_klass(name)
    end

    private

    def _find_klass(name)
      namespace.constantize.const_get(name.to_s.camelize)
    end
  end
end
