module Pavlov
  module Helpers
    class SafeEvaluator < BasicObject
      def initialize target_instance, caller_instance
        @target_instance, @caller_instance = target_instance, caller_instance
      end

      def method_missing method_name, *args
        if method_name[-1] == '='
          @target_instance.public_send method_name, *args
        else
          @caller_instance.send method_name, *args
        end
      end
    end
  end
end