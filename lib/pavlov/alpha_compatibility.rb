require 'pavlov'

module Pavlov
  class ValidationError < StandardError
  end

  module Validations
    def validate_hexadecimal_string param_name, param
      return if param.is_a?(String) && /\A[\da-fA-F]+\Z/.match(param)

      raise Pavlov::ValidationError,  "#{param_name.to_s} should be an hexadecimal string."
    end

    def validate_regex param_name, param, regex, message
      return if regex.match param

      raise Pavlov::ValidationError, "#{param_name.to_s} #{message}"
    end

    def validate_integer param_name, param, opts = {}
      return if opts[:allow_blank] && param.blank?
      return if param.is_a?(Integer)

      raise Pavlov::ValidationError, "#{param_name.to_s} should be an integer."
    end

    def validate_in_set param_name, param, set
      return if set.include? param

      raise Pavlov::ValidationError, "#{param_name.to_s} should be on of these values: #{set.inspect}."
    end

    def validate_string param_name, param
      return if param.is_a?(String)

      raise Pavlov::ValidationError, "#{param_name.to_s} should be a string."
    end

    def validate_nonempty_string param_name, param
      return if param.is_a?(String) && !param.empty?

      raise Pavlov::ValidationError, "#{param_name.to_s} should be a nonempty string."
    end

    def validate_integer_string param_name, param
      return if param.is_a?(String) && /\A\d+\Z/.match(param)

      raise Pavlov::ValidationError, "#{param_name.to_s} should be an integer string."
    end

    def validate_not_nil param_name, param
      return unless param.nil?

      raise Pavlov::ValidationError, "#{param_name.to_s} should not be nil."
    end
  end

  module Operation
    include Pavlov::Validations
    module ClassMethods
      def arguments(*args)
        # Add generic attribute for each argument
        args.each do |argument|
          attribute argument, Object
        end

        # Add attribute for pavlov_options
        attribute :pavlov_options, Hash, default: {}
      end
    end
  end
end
