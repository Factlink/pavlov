require_relative 'spec_helper'
require 'pavlov'

describe Pavlov do
  describe "#string_to_classname" do
    it "should return the camel cased class" do
      class_name = Pavlov.string_to_classname('foo')

      expect(class_name).to eq 'Foo'
    end
    
    it "should expand '/' to '::'" do
      class_name = Pavlov.string_to_classname('foo/bar')

      expect(class_name).to eq 'Foo::Bar'
    end
  end
end
