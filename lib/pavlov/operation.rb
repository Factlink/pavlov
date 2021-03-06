require_relative 'concern'
require 'pavlov/helpers'
require 'virtus'
require_relative 'access_denied'

require 'active_model'
require 'active_model/naming'
require 'active_model/errors'

module Pavlov
  class ValidationError < StandardError
  end

  module Operation
    extend Pavlov::Concern
    include Pavlov::Helpers

    included do
      include Virtus
      extend ActiveModel::Naming
      extend ActiveModel::Translation

      attribute :pavlov_options, Hash, default: {}
    end

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end

    def valid?
      check_validation
      errors.empty?
    rescue Pavlov::ValidationError
      false
    end

    def call(*args, &block)
      fail Pavlov::ValidationError, "Some validations fail, cannot execute:\n  #{errors.to_a.join "\n  "}" unless valid?

      check_authorization
      execute(*args, &block)
    end

    private

    def check_authorization
      raise_unauthorized unless authorized?
    end

    def raise_unauthorized(message = 'Unauthorized')
      fail Pavlov::AccessDenied, message
    end

    def check_validation
      fail Pavlov::ValidationError, "Missing arguments: #{missing_arguments.inspect}" if missing_arguments.any?
      validate
    end

    def missing_arguments
      attribute_set.select do |attribute|
        !attribute.options.key?(:default) && send(attribute.name).nil?
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
