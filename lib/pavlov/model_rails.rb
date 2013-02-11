module Pavlov
  module RailsModel
    module ClassMethods
      def _to_partial_path
        element = ActiveSupport::Inflector.underscore(ActiveSupport::Inflector.demodulize(self))
        collection = ActiveSupport::Inflector.tableize(self)
        "#{collection}/#{element}".freeze
      end
    end

    # todo: this is ugly, how can we do this better?
    def self.included(base)
      base.extend(ClassMethods)
    end

    def to_model
      self
    end

    def to_key
      persisted? ? [id] : nil
    end

    def to_param
      persisted? ? id : nil
    end    

    def to_partial_path
      puts self.class.inspect
      self.class._to_partial_path
    end
  
    def persisted?
      !id.nil?
    end
  end
end