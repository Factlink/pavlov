require 'active_model'

module ActiveModel
  module Validations
    class StringValidator < EachValidator
      def validate_each(record, attribute, value)
        unless value.is_a? String
          record.errors.add attribute, "should be a string."
        end
      end
    end

    module HelperMethods
      def validate_string(*attr_names)
        validates_with StringValidator, _merge_attributes(attr_names)
      end
    end
  end
end
