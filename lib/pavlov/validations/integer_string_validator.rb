require 'active_model'

module ActiveModel
  module Validations
    class IntegerStringValidator < EachValidator
      def validate_each(record, attribute, value)
        unless value.is_a? String and /\A\d+\Z/.match value
          record.errors.add attribute, "should be a integer string."
        end
      end
    end

    module HelperMethods
      def validate_integer_string(*attr_names)
        validates_with IntegerStringValidator, _merge_attributes(attr_names)
      end
    end
  end
end
