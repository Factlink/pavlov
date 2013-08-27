require 'spec_helper'
require 'pavlov/support/inflector'

describe Pavlov::Inflector do
  describe '#string_to_classname' do
    it 'should return the camel cased class' do
      class_name = Pavlov::Inflector.camelize('foo')
      expect(class_name).to eq 'Foo'
    end

    it "should expand '/' to '::'" do
      class_name = Pavlov::Inflector.camelize('foo/bar')
      expect(class_name).to eq 'Foo::Bar'
    end
  end
end
