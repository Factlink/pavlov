require 'active_support/concern'

module Pavlov
  module Operation
    extend ActiveSupport::Concern
    include Pavlov::Helpers

    def initialize(args = {})
      set_instance_variables(args)
      validate
      check_authorization
      finish_initialize if respond_to? :finish_initialize
    end

    def set_instance_variables(args)
      self.class.arguments.each do |key, options|
        value   = args.fetch(key) do
          options.fetch(:default) do
            raise ArgumentError, "Missing argument: #{key}" unless value or options.has_key?(:default)
          end
        end

        instance_variable_set("@#{key}", value)
      end
    end

    def validate
      if respond_to? :valid?
        valid?
      else
        true
      end
    end

    def call(*args, &block)
      execute(*args, &block)
    end

    private

    def pavlov_options
      @options ||= {}
    end

    def raise_unauthorized(message='Unauthorized')
      raise Pavlov::AccessDenied, message
    end

    def check_authorization
      raise_unauthorized if respond_to? :authorized? and not authorized?
    end

    module ClassMethods
      def argument key, options = {}
        @arguments ||= {}
        @arguments[key] = options
        class_eval { attr_reader key }
      end

      def arguments
        @arguments || {}
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
