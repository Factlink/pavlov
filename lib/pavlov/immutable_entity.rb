require_relative 'entity'
require_relative 'errors/immutable_error'

module Pavlov
  class ImmutableEntity < Pavlov::Entity
    def self.attributes *args
      @attributes ||= []
      args.each do |attribute_name|
        @attributes << attribute_name
        define_attribute_writer attribute_name
        attr_reader attribute_name
      end
    end

    def update hash = {}, &block
      dup.send :mutate, hash, &block
    end

    private
    def mutate hash, &block
      make_temporary_mutatable do
        copy_hash_values hash
        safely_evaluate_against(&block) if block_given?
      end
      raise Pavlov::Errors::Immutable.new unless valid?
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
