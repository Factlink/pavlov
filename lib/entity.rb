module Pavlov
  class Entity
    private_class_method :new

    def self.attributes *args
      args.each do |attribute_name|
        define_attribute_setter attribute_name
        define_attribute_getter attribute_name
      end
    end

    def self.create &block
      safely_evaluate_against new, &block
    end

    def update &block
      self.class.safely_evaluate_against self.dup, &block
    end

    private
    def self.safely_evaluate_against target_instance, &block
      if block_given?
        target_instance.instance_variable_set :@mutable, true
        caller_instance = eval "self", block.binding
        evaluator = SafeEvaluator.new(target_instance, caller_instance)
        evaluator.instance_eval &block      
        target_instance.instance_variable_set :@mutable, false
      end
      target_instance
    end

    class SafeEvaluator < BasicObject
      def initialize target_instance, caller_instance
        @target_instance, @caller_instance = target_instance, caller_instance
      end

      def method_missing method_name, *args
        if method_name[-1] == '='
          @target_instance.public_send method_name, *args
        else
          @caller_instance.send method_name, *args
        end
      end
    end

    def self.define_attribute_setter attribute_name
      define_method attribute_name do
        instance_variable_symbol = self.class.instance_variable_symbol attribute_name
        instance_variable_get instance_variable_symbol
      end
    end

    def self.define_attribute_getter attribute_name
      define_method "#{attribute_name}=" do |new_value|
        raise_immutable unless @mutable
        instance_variable_symbol = self.class.instance_variable_symbol attribute_name
        instance_variable_set instance_variable_symbol, new_value
      end
    end

    def self.instance_variable_symbol attribute_name
      "@#{attribute_name}".to_sym
    end

    def raise_immutable
      raise "This entity is immutable, please use 'instance = #{self.class.name}.create do; self.attribute = 'value'; end' or 'instance = instance.update do; self.attribute = 'value'; end'."
    end
  end
end