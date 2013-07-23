require 'active_support/concern'
require 'pavlov/validations'
require 'pavlov/helpers'
require 'virtus'
require_relative 'access_denied'

module Pavlov
  module Operation
    extend ActiveSupport::Concern
    include Pavlov::Helpers
    include Pavlov::Validations
    include Virtus

    def validate
      return false unless attributes_without_defaults_have_values
      if respond_to? :valid?
        raise Pavlov::ValidationError, "an argument is invalid" unless valid?
      else
        true
      end
    end

    def call(*args, &block)
      validate
      check_authorization
      execute(*args, &block)
    end

    private

    def pavlov_options
      @options
    end

    def raise_unauthorized(message='Unauthorized')
      raise Pavlov::AccessDenied, message
    end

    def check_authorization
      raise_unauthorized if respond_to? :authorized?, true and not authorized?
    end

    def attributes_without_defaults_have_values
      attributes_without_value = attribute_set.select do |attribute|
        not attribute.options.has_key?(:default) and send(attribute.name).nil?
      end
      attributes_without_value.empty?
    end

    module ClassMethods
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
