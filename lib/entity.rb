module Pavlov
  class Entity
    private_class_method :new

    def self.attributes *args
      @@attribute_names = []
      args.each do |attribute_name|
        define_attribute_setter attribute_name
        define_attribute_getter attribute_name
        @@attribute_names << attribute_name
      end
    end

    def self.create &block
      update_instance &block
    end

    def update &block
      self.class.update_instance self, &block
    end

    private
    def method_missing(method, *args, &block)
      if @block_binding_self.nil?
        super
      end
      # If method isn't found here, look in the closure
      @block_binding_self.send method, *args, &block
    end

    def self.update_instance old_instance = nil, &block
      new_instance = new

      copy_attribute_values old_instance, new_instance

      safely_evaluate_against(new_instance, &block) if block_given?
      
      new_instance
    end

    def self.safely_evaluate_against instance, &block
      instance.instance_variable_set :@mutable, true
      instance.instance_variable_set :@block_binding_self, (eval "self", block.binding)
      evaluator = SafeEvaluator.new(instance)
      evaluator.instance_eval &block      
      instance.instance_variable_set :@mutable, false
    end

    class SafeEvaluator < BasicObject
      def initialize obj
        @obj = obj
      end

      def method_missing method_name, *args
        @obj.public_send method_name, *args
      end
    end

    def self.copy_attribute_values old_instance, new_instance
      if not old_instance.nil?
        @@attribute_names.each do |attribute_name|
          attribute_instance_variable_name = "@#{attribute_name}".to_sym
          old_value = old_instance.send attribute_name.to_sym
          new_instance.instance_variable_set attribute_instance_variable_name, old_value
        end
      end
    end

    def self.define_attribute_setter attribute_name
      define_method attribute_name do
        attribute_instance_variable_name = "@#{attribute_name}".to_sym
        instance_variable_get attribute_instance_variable_name
      end
    end

    def self.define_attribute_getter attribute_name
      define_method "#{attribute_name}=" do |new_value|
        if @mutable
          attribute_instance_variable_name = "@#{attribute_name}".to_sym
          instance_variable_set attribute_instance_variable_name, new_value
        else
          raise "This entity is immutable, please use 'instance = #{self.class.name}.create do; self.attribute = 'value'; end' or 'instance = instance.update do; self.attribute = 'value'; end'."
        end
      end
    end
  end
end