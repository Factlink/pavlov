require 'active_support/concern'

module Pavlov
  class AccessDenied < StandardError; end

  module Operation
    extend ActiveSupport::Concern
    include Pavlov::Helpers


    def initialize(args = {})
      @callbacks = {}
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

      self.class.callbacks.each do |key, options|
        if value = args["on_#{key}".to_sym]
          @callbacks[key] ||= []
          @callbacks[key] << value
        end
      end
    end

    def validate
      return valid? if respond_to? :valid?
      true
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

    def execute_callbacks_for(key, *args)
      @callbacks[key] ||= []
      @callbacks[key].each do |callback|
        callback.call(*args)
      end
    end

    module ClassMethods
      def argument key, options = {}
        @arguments ||= {}
        @arguments[key] = options
        class_eval { attr_reader key }
      end

      def callback key, options = {}
        @callbacks ||= {}
        @callbacks[key] = options
        class_eval <<-END
          def on_#{key}(&block)
            @callbacks[#{key.to_sym.inspect}] ||= []
            @callbacks[#{key.to_sym.inspect}] << block
          end
        END
      end

      def arguments
        @arguments || {}
      end

      def callbacks
        @callbacks || {}
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
