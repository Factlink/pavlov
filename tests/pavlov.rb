require 'minitest/autorun'
require_relative 'test_helper'
require_relative '../lib/pavlov.rb'

describe Pavlov do
  describe "#string_to_classname" do
    it "should return the camel cased class" do
      Pavlov.string_to_classname('foo').must_equal 'Foo'
    end
    it "should expand '/' to '::'" do
      Pavlov.string_to_classname('foo/bar').must_equal 'Foo::Bar'
    end
  end
end
