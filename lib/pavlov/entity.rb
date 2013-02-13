require 'active_model'
require_relative 'helpers/safe_evaluator'

module Pavlov
  class Entity
    include ActiveModel::Validations

    attr_accessor :options

    def self.attributes *args
      @attributes ||= []
      args.each do |attribute_name|
        @attributes << attribute_name
        attr_accessor attribute_name
      end
    end

    def self.new *parameters, &block
      # make backwards compatabli object creation possible.
      parameters = self.compatability parameters
      parameters = [parameters] if parameters.is_a? Hash

      # setup default value
      parameters = [{}] if parameters == []

      super().send :mutate, *parameters, &block
    end

    def update hash = {}, &block
      mutate hash, &block
    end

    private
    def self.compatability parameters
      new_parameters = parameters
      if parameters.size > 1 or (parameters.size == 1 and @attributes.size == 0)
        if @attributes.size == parameters.size
          new_parameters = {}
          @attributes.each_with_index {|k,i| new_parameters[@attributes[i]] = parameters[i]}
        elsif @attributes.size + 1 == parameters.size
          new_parameters = {}
          @attributes.each_with_index {|k,i| new_parameters[@attributes[i]] = parameters[i]}
          new_parameters[:options] = parameters.last
        end
      elsif parameters.size == 1 and @attributes.size == 1
        unless parameters.first.is_a? Hash and parameters.first.has_key?(@attributes.first)
          new_parameters = {}
          new_parameters[@attributes.first] = parameters.first
        end
      end
      new_parameters
    end

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
    end
  end
end
