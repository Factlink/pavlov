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

    def valid?
      check_validation
      true
    rescue Pavlov::ValidationError
      false
    end

    def call(*args, &block)
      check_validation
      check_authorization
      execute(*args, &block)
    end

    private

    def check_authorization
      raise_unauthorized unless authorized?
    end

    def raise_unauthorized(message = 'Unauthorized')
      raise Pavlov::AccessDenied, message
    end

    def check_validation
      raise Pavlov::ValidationError, 'some arguments were not given' if attributes_without_defaults_missing_values?
      validate
    end

    def attributes_without_defaults_missing_values?
      attribute_set.find_index do |attribute|
        !attribute.options.has_key?(:default) && send(attribute.name).nil?
      end
    end

    def validate
      # no-op, users should override this
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
