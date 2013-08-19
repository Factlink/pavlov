require_relative 'concern'
require 'pavlov/operation'

module Pavlov
  module Interactor
    extend Pavlov::Concern
    include Pavlov::Operation

    module ClassMethods
      # make our interactors behave as Resque jobs
      def perform(*args)
        new(*args).call
      end

      def queue
        @queue ||= :interactor_operations
      end
    end
  end
end
