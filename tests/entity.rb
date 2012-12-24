require 'minitest/autorun'
require_relative '../lib/entity'

class EntityTests < MiniTest::Unit::TestCase

  class TestObject < Entity
    attr_accessor :name, :test
    private
    def private_method
      puts 'I''m private'
    end
  end

  def test_returns_not_nil
    test_object = TestObject.create do

    end

    refute_nil test_object
  end

  def test_returns_correct_class
    test_class = TestObject
    test_object = test_class.create do

    end

    assert_equal test_class, test_object.class
  end

  def test_can_set_attribute
    name1 = 'Je naam is mooi.'
    test_object = TestObject.create do
      self.name = name1
    end

    assert_equal name1, test_object.name
  end

  def test_can_set_attribute_with_a_local_helper_method
    name1 = 'Je naam is mooi.'
    test_object = TestObject.create do
      self.name = helper_method
    end

    assert_equal helper_method, test_object.name
  end

  def helper_method
    "Ik ben een helper"
  end

  def test_cant_set_private_attribute
    name1 = 'Je naam is mooi.'
    
    assert_raises (NoMethodError) {
      test_object = TestObject.create do
        self.private_method
      end
    }
  end

  def test_can_set_two_attributes
    name1 = 'Je naam is mooi.'
    test_object = TestObject.create do
      self.name = helper_method
      self.test = false
    end

    assert_equal helper_method, test_object.name
    assert_equal false, test_object.test
  end
end