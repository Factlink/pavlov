require 'virtus/version'

# For newer versions, we have fixed this upstream. Until a new release is
# made and we can bump the required version of Virtus, we have this
# monkeypatch.
if Virtus::VERSION == '0.5.5'
  module Virtus
    module InstanceMethods
      def initialize(attributes = nil)
        self.attributes = attributes if attributes
        super()
      end
    end
  end
end