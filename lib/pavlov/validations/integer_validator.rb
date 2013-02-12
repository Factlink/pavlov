require 'active_model'

module ActiveModel
  module Validations
    class IntegerValidator < EachValidator
      def validate_each(record, attribute, value)
        unless value.is_a? Integer
          record.errors.add attribute, "should be a integer."
        end
      end
    end

    module HelperMethods
      def validate_integer(*attr_names)
        validates_with IntegerValidator, _merge_attributes(attr_names)
      end
    end
  end
end