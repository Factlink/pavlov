require 'pavlov'

module Pavlov
  def self.old_command command_name, *args
    class_name = "Commands::"+string_to_classname(command_name)
    klass = get_class_by_string(class_name)
    attributes = arguments_to_attributes(klass, args)
    klass.new(attributes).call
  end

  def self.old_interactor command_name, *args
    class_name = "Interactors::"+string_to_classname(command_name)
    klass = get_class_by_string class_name
    attributes = arguments_to_attributes(klass, args)
    klass.new(attributes).call
  end

  def self.old_query command_name, *args
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

  module Helpers
    def old_interactor name, *args
      args = add_compatablity_pavlov_options args
      Pavlov.old_interactor name, *args
    end

    def old_query name, *args
      args = add_compatablity_pavlov_options args
      Pavlov.old_query name, *args
    end

    def old_command name, *args
      args = add_compatablity_pavlov_options args
      Pavlov.old_command name, *args
    end

    private
    def add_compatablity_pavlov_options args
      # TODO: we should do this at a point where we know how many arguments we need
      # so we can decide if we need to merge with another options object or
      # just add it.
      if pavlov_options != {}
        args << pavlov_options
      end
      args
    end
  end

  module Operation
    module ClassMethods
      def arguments(*args)
        # Add generic attribute for each argument
        args.each do |argument|
          attribute argument, Object
        end
      end
    end
  end
end
