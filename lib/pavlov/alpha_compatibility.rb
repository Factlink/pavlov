require 'pavlov'

module Pavlov
  class ValidationError < StandardError
  end

  module Validations
    def validate_hexadecimal_string param_name, param
      return if param.is_a?(String) && /\A[\da-fA-F]+\Z/.match(param)

      errors.add param_name, 'should be an hexadecimal string.'
    end

    def validate_regex param_name, param, regex, message
      return if regex.match param

      errors.add param_name, "#{message}"
    end

    def validate_integer param_name, param, opts = {}
      return if opts[:allow_blank] && param.blank?
      return if param.is_a?(Integer)

      errors.add param_name, 'should be an integer.'
    end

    def validate_in_set param_name, param, set
      return if set.include? param

      errors.add param_name, "should be on of these values: #{set.inspect}."
    end

    def validate_string param_name, param
      return if param.is_a?(String)

      errors.add param_name, 'should be a string.'
    end

    def validate_nonempty_string param_name, param
      return if param.is_a?(String) && !param.empty?

      errors.add param_name, 'should be a nonempty string.'
    end

    def validate_integer_string param_name, param
      return if param.is_a?(String) && /\A\d+\Z/.match(param)

      errors.add param_name, 'should be an integer string.'
    end

    def validate_not_nil param_name, param
      return unless param.nil?

      errors.add param_name, 'should not be nil.'
    end
  end

  module Operation
    include Pavlov::Validations
    module ClassMethods
      def arguments(*args)
        # Add generic attribute for each argument
        args.each do |argument|
          attribute argument, Object, default: nil
        end
      end
    end
  end
end
