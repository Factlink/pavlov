require 'active_model'
require_relative 'helpers/safe_evaluator'

module Pavlov
  class Model
    include ActiveModel::Validations

    def self.attributes *args
      @attributes ||= []
      args.each do |attribute_name|
        @attributes << attribute_name
        attr_accessor attribute_name
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
      self
    end

    def copy_hash_values hash
      hash.each {|key,value| send("#{key}=",value)}
    end

    def safely_evaluate_against &block
      caller_instance = eval "self", block.binding
      evaluator = Pavlov::Helpers::SafeEvaluator.new(self, caller_instance)
      evaluator.instance_eval(&block)
      self
    end
  end
end