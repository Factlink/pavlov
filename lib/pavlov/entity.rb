require_relative 'helpers/safe_evaluator'

module Pavlov
  class Entity
    def self.attributes *args
      args.each do |attribute_name|
        define_attribute_writer attribute_name
        attr_reader attribute_name
      end
    end

    def self.new hash = {}, &block
      super().send :mutate, hash, &block
    end

    def update hash = {}, &block
      self.dup.send :mutate, hash, &block
    end

    private
    def mutate hash, &block
      copy_hash_values hash
      safely_evaluate_against(&block) if block_given?
      validate if respond_to? :validate
      self
    end

    def copy_hash_values hash
      make_temporary_mutatable do
        hash.each {|key,value| send("#{key}=",value)}
      end
    end

    def safely_evaluate_against &block
      make_temporary_mutatable do
        caller_instance = eval "self", block.binding
        evaluator = Pavlov::Helpers::SafeEvaluator.new(self, caller_instance)
        evaluator.instance_eval(&block)
      end
      self
    end

    def make_temporary_mutatable &block
      @mutable = true
      block.call
      @mutable = false
    end

    def self.define_attribute_writer attribute_name
      define_method "#{attribute_name}=" do |new_value|
        raise_not_mutable unless @mutable
        instance_variable_symbol = "@#{attribute_name}".to_sym
        instance_variable_set instance_variable_symbol, new_value
      end
    end

    def raise_not_mutable
      raise "This entity is immutable, please use 'instance = #{self.class.name}.new do; self.attribute = 'value'; end' or 'instance = instance.update do; self.attribute = 'value'; end'."
    end
  end
end
