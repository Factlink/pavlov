require 'active_support/inflector'

module Pavlov
  class OperationFinder
    attr_reader :namespace

    def initialize(namespace)
      @namespace = namespace
    end

    def find(name)
      class_name = namespace + "::"+ name.to_s.camelize
      class_name.constantize
    end
  end
end
