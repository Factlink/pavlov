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

    def raise_unauthorized(message='Unauthorized')
      raise Pavlov::AccessDenied, message
    end

    def check_authorization
      raise_unauthorized if respond_to? :authorized?, true and not authorized?
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
