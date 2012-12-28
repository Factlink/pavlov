module Pavlov
  class Entity
    private_class_method :new

    def self.attributes *args
      args.each do |attribute_name|
        define_attribute_setter attribute_name
        define_attribute_getter attribute_name
      end
    end

    def self.create hash = nil, &block
      update new, hash, &block
    end

    def update hash = nil, &block
      self.class.update self.dup, hash, &block
    end

    private
    def self.update base_instance, hash, &block
      copy_hash_values base_instance, hash if not hash.nil?
      safely_evaluate_against base_instance, &block if block_given?
      base_instance
    end

    def self.copy_hash_values target_instance, hash
      make_temporary_mutatable target_instance do
        hash.each {|key,value| target_instance.send("#{key}=",value)}
      end
    end

    def self.safely_evaluate_against target_instance, &block
      make_temporary_mutatable target_instance do
        caller_instance = eval "self", block.binding
        evaluator = SafeEvaluator.new(target_instance, caller_instance)
        evaluator.instance_eval &block      
      end
      target_instance
    end

    def self.make_temporary_mutatable target_instance, &block
      target_instance.instance_variable_set :@mutable, true
      block.call
      target_instance.instance_variable_set :@mutable, false
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
        raise_not_mutable unless @mutable
        instance_variable_symbol = self.class.instance_variable_symbol attribute_name
        instance_variable_set instance_variable_symbol, new_value
      end
    end

    def self.instance_variable_symbol attribute_name
      "@#{attribute_name}".to_sym
    end

    def raise_not_mutable
      raise "This entity is immutable, please use 'instance = #{self.class.name}.create do; self.attribute = 'value'; end' or 'instance = instance.update do; self.attribute = 'value'; end'."
    end
  end
end