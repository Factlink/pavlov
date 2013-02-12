require 'active_model'

module ActiveModel
  module Validations
    class HexadecimalValidator < EachValidator
      def validate_each(record, attribute, value)
        unless value.is_a? String and /\A[\da-fA-F]+\Z/.match value
          record.errors.add attribute, "should be an hexadecimal string."
        end
      end
    end

    module HelperMethods
      def validate_hexadecimal_string(*attr_names)
        validates_with HexadecimalValidator, _merge_attributes(attr_names)
      end
    end
  end
end