require_relative 'concern'
require 'pavlov/helpers'
require 'virtus'
require_relative 'access_denied'

module Pavlov
  class ValidationError < StandardError
  end

  module Operation
    extend Pavlov::Concern
    include Pavlov::Helpers
    include Virtus

    def validate
      return false if attributes_without_defaults_missing_values?

      raise Pavlov::ValidationError, 'an argument is invalid' unless valid?

      true
    end

    def valid?
      true
    end

    def call(*args, &block)
      validate
      check_authorization
      execute(*args, &block)
    end

    private

    def raise_unauthorized(message = 'Unauthorized')
      raise Pavlov::AccessDenied, message
    end

    def check_authorization
      raise_unauthorized unless authorized?
    end

    def attributes_without_defaults_missing_values?
      attribute_set.find_index do |attribute|
        !attribute.options.has_key?(:default) && send(attribute.name).nil?
      end
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
