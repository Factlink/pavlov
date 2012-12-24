require 'minitest/autorun'
require_relative '../lib/entity'

class EntityTests < MiniTest::Unit::TestCase

  class TestObject < Pavlov::Entity
    attributes :name, :test

    private
    def private_method
      puts 'I''m private'
    end
  end

  def test_returns_not_nil
    test_object = TestObject.create

    refute_nil test_object
  end

  def test_returns_correct_class
    test_class = TestObject
    test_object = test_class.create

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
    "I'm a helper method for testing purposes."
  end

  def test_cant_call_private_methods
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
      self.name = 'Je naam is mooi.'
      self.test = false
    end

    assert_equal name1, test_object.name
    assert_equal false, test_object.test
  end

  def test_cant_mutate_entity
    test_object = TestObject.create

    exception = assert_raises (RuntimeError) {
      test_object.name = 'bla'
    }
    assert_equal "This entity is immutable, please use 'instance = EntityTests::TestObject.create do; self.attribute = 'value'; end' or 'instance = instance.update do; self.attribute = 'value'; end'.", 
      exception.message
  end

  def test_can_update_entity
    test_object = TestObject.create
    other_name = 'Ik heet Pricilla.'
    
    test_object = test_object.update do
      self.name = other_name
    end

    assert_equal other_name, test_object.name
  end

  def test_can_partially_update_entity
    name1 = 'Je naam is mooi.'
    test_object = TestObject.create do
      self.test = name1
    end

    other_name = 'Ik heet Pricilla.'
    test_object = test_object.update do
      self.name = other_name
    end

    assert_equal name1, test_object.test
    assert_equal other_name, test_object.name
  end

  def test_returns_other_object_on_update
    test_object = TestObject.create 

    updated_test_object = test_object.update

    refute_equal test_object.object_id, updated_test_object.object_id
  end

  def test_cant_call_new
    exception = assert_raises (NoMethodError) {
      TestObject.new
    }

    assert_equal "private method `new' called for EntityTests::TestObject:Class", exception.message
  end

  def test_can_call_missing_method
    test_object = TestObject.create

    puts test_object.inspect

    exception = assert_raises (NoMethodError) {
      test_object.method_is_not_there
    }

    assert_match /undefined method `method_is_not_there' for #<EntityTests::TestObject.*/, exception.message
  end
end