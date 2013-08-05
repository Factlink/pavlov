require 'pavlov/validation_error'

module Pavlov
  module Validations
    def validate_hexadecimal_string param_name, param
      #warn "[DEPRECATION] `validate_hexadecimal_string` is deprecated. Please use the ActiveModel validation instead."
      raise Pavlov::ValidationError,  "#{param_name.to_s} should be an hexadecimal string." unless param.is_a? String and /\A[\da-fA-F]+\Z/.match param
    end

    def validate_regex param_name, param, regex, message
      #warn "[DEPRECATION] `validate_integer` is deprecated. Please use the default format_of ActiveModel validator instead."
      raise Pavlov::ValidationError, "#{param_name.to_s} #{message}" unless regex.match param
    end

    def validate_integer param_name, param, opts = {}
      #warn "[DEPRECATION] `validate_integer` is deprecated. Please use the default numericality ActiveModel validator with the :only_integer option instead."
      return if opts[:allow_blank] && param.blank?
      raise Pavlov::ValidationError, "#{param_name.to_s} should be an integer." unless param.is_a? Integer
    end

    def validate_in_set param_name, param, set
      raise Pavlov::ValidationError, "#{param_name.to_s} should be on of these values: #{set.inspect}." unless set.include? param
    end

    def validate_string param_name, param
      #warn "[DEPRECATION] `validate_string` is deprecated. Please use the ActiveModel validation instead."
      raise Pavlov::ValidationError, "#{param_name.to_s} should be a string." unless param.is_a? String
    end

    def validate_nonempty_string param_name, param
      #warn "[DEPRECATION] `validate_string` is deprecated. Please use the ActiveModel validation with the :non_empty option instead."
      raise Pavlov::ValidationError, "#{param_name.to_s} should be a nonempty string." unless param.is_a?(String) && not(param.nil?) && not(param.empty?)
    end

    def validate_integer_string param_name, param
      #warn "[DEPRECATION] `validate_integer_string` is deprecated. Please use the ActiveModel validation instead."
      raise Pavlov::ValidationError, "#{param_name.to_s} should be an integer string." unless param.is_a? String and /\A\d+\Z/.match param
    end

    def validate_not_nil param_name, param
      #warn "[DEPRECATION] `validate_not_nil` is deprecated. Please use the default presence ActiveModel validator instead."
      raise Pavlov::ValidationError, "#{param_name.to_s} should not be nil." if param.nil?
    end
  end
end
