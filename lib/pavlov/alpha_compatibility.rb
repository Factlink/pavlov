require 'pavlov'

module Pavlov
  def self.old_command command_name, *args
    klass = class_for_command(command_name)
    command command_name, arguments_to_attributes(klass, args)
  end

  def self.old_interactor interactor_name, *args
    klass = class_for_interactor(interactor_name)
    interactor interactor_name, arguments_to_attributes(klass, args)
  end

  def self.old_query query_name, *args
    klass = class_for_query(query_name)
    query query_name, arguments_to_attributes(klass, args)
  end

  def self.arguments_to_attributes(operation_class, arguments)
    attribute_keys = operation_class.attribute_set.map(&:name)

    # TODO: this can be done so much better, but I don't know how.
    hash = {}
    arguments.each_with_index do |value, index|
      hash[attribute_keys[index].to_sym] = value
    end
    hash
  end

  module Helpers
    def old_interactor name, *args
      args = add_compatibility_pavlov_options args
      Pavlov.old_interactor name, *args
    end

    def old_query name, *args
      args = add_compatibility_pavlov_options args
      Pavlov.old_query name, *args
    end

    def old_command name, *args
      args = add_compatibility_pavlov_options args
      Pavlov.old_command name, *args
    end

    private

    def add_compatibility_pavlov_options args
      # TODO: we should do this at a point where we know how many arguments we need
      # so we can decide if we need to merge with another options object or
      # just add it.
      new_args = Array(args)
      new_args << pavlov_options unless pavlov_options == {}
      new_args
    end
  end

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
