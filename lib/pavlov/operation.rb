require 'active_support/concern'

module Pavlov
  module Operation
    extend ActiveSupport::Concern
    include Pavlov::Helpers
    include Pavlov::Validations
    include Pavlov::Utils

    def initialize(*params)
      keys, names = extract_arguments(params)
      set_instance_variables keys, names
      validate
      check_authority
      finish_initialize if respond_to? :finish_initialize
    end

    def authorized?
      raise NotImplementedError
    end

    def validate
      true
    end

    def call(*args, &block)
      self.execute(*args, &block)
    end

    private

    def pavlov_options
      @options
    end

    def extract_arguments(params)
      keys = (respond_to? :arguments) ? arguments : []
      names = params.first(keys.length)

      if params.length == keys.length + 1
        @options = params.last
      elsif params.length == keys.length
        @options = {}
      else
        raise "wrong number of arguments."
      end

      [keys, names]
    end

    def set_instance_variables(keys, names)
      (keys.zip names).each do |pair|
        name = "@" + pair[0].to_s
        value = pair[1]
        instance_variable_set(name, value)
      end
    end

    def raise_unauthorized(message='Unauthorized')
      raise Pavlov::AccessDenied, message
    end

    def check_authority
      raise_unauthorized unless authorized?
    end

    module ClassMethods
      # arguments :foo, :bar
      #
      # results in
      #
      # def initialize(foo, bar)
      #   @foo = foo
      #   @bar = bar
      # end
      def arguments *keys
        define_method :arguments do
          keys
        end

        class_eval do
          attr_reader(*keys)
        end
      end

      # make our interactors behave as Resque jobs
      def perform(*args)
        new(*args).call
      end

      def queue
        @queue || :interactor_operations
      end
    end
  end
end
