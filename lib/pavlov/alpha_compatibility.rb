require 'pavlov'

module Pavlov
  def self.command command_name, *args
    class_name = "Commands::"+string_to_classname(command_name)
    klass = get_class_by_string(class_name)
    attributes = arguments_to_attributes(klass, args)
    klass.new(attributes).call
  end

  def self.interactor command_name, *args
    class_name = "Interactors::"+string_to_classname(command_name)
    klass = get_class_by_string class_name
    attributes = arguments_to_attributes(klass, args)
    klass.new(attributes).call
  end

  def self.query command_name, *args
    class_name = "Queries::"+string_to_classname(command_name)
    klass = get_class_by_string class_name
    attributes = arguments_to_attributes(klass, args)
    klass.new(attributes).call
  end

  def self.arguments_to_attributes(operation_class, arguments)
    attribute_keys = operation_class.attribute_set.map(&:name)
    attributes_and_arguments = attribute_keys.zip(arguments)
    Hash[attributes_and_arguments]
  end

  module Operation
    module ClassMethods
      def arguments(*args)
        # Add generic attribute for each argument
        args.each do |argument|
          attribute argument, Object
        end

        # Add attribute for pavlov_options
        attribute :pavlov_options, Hash
      end
    end
  end
end