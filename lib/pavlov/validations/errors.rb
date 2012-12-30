module Pavlov
  module Validations
    module Errors
      include Enumerable

      def initialize 
        @messages = {}
      end

      def each &block
        @messages.each_key do |attribute|
          @messages[attribute.to_s].each { |error| block.call attribute, error }
        end
      end

      def add attribute, error_message
        (@messages[attribute.to_s] ||= []) << error_message
      end
    end
  end
end