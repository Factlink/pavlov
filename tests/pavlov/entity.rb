require 'minitest/autorun'

require_relative '../../lib/pavlov/entity'

describe Pavlov::Entity do
  describe '.new' do
    let 'test_class' do
      Class.new Pavlov::Entity do
        attributes :name, :test

        private
        def private_method
          puts 'I''m private'
        end
      end
    end

    let 'helper_method' do
      'I''m a helper method for testing purposes.'
    end

    let 'default_name' do
      'This is your name.'
    end

    it 'must return not nil' do
      test_object = test_class.new

      refute_nil test_object
    end

    it 'must return the correct class' do
      test_object = test_class.new

      assert_equal test_class, test_object.class
    end

    it 'must set the attribute when given a block' do
      test_object = test_class.new do
        self.name = default_name
      end

      assert_equal default_name, test_object.name
    end

    it 'must set the attribute when given a hash' do
      test_object = test_class.new({name: default_name})

      assert_equal default_name, test_object.name
    end


    it 'must set the attribut to the value of a local method' do
      test_object = test_class.new do
        self.name = helper_method
      end

      assert_equal helper_method, test_object.name
    end

    it 'must not allow to call private methods' do
      assert_raises(NoMethodError) {
        test_object = test_class.new do
          self.private_method
        end
      }
    end

    it 'must be able to set two attributes when given a block' do
      test_value = false

      test_object = test_class.new do
        self.name = default_name
        self.test = test_value
      end

      assert_equal default_name, test_object.name
      assert_equal test_value, test_object.test
    end

    it 'must be able to set two attributes when given a hash' do
      test_value = false

      test_object = test_class.new({name: default_name, test: test_value})

      assert_equal default_name, test_object.name
      assert_equal test_value, test_object.test
    end

    it 'gives precedence to the block when given a hash and a block' do
      test_value = false

      test_object = test_class.new({name: 'string that is overwritten', test: true}) do
        self.name = default_name
        self.test = test_value
      end

      assert_equal default_name, test_object.name
      assert_equal test_value, test_object.test
    end
  end

  describe 'interactions with .validate' do
    let :succes_class do
      Class.new Pavlov::Entity do
        def validate
          @mock.validate_call unless @mock.nil?
        end

        attributes :mock
      end
    end

    it 'calls validate after creating and returns the entity when validations is succesfull' do
      mock = MiniTest::Mock.new

      mock.expect :validate_call, nil
      mock.expect :nil?, false

      test_object = succes_class.new do
        self.mock = mock
      end

      mock.verify
      refute_nil test_object
    end

    it 'calls validate after update and returns the entity when validations is succesfull' do
      mock = MiniTest::Mock.new
      test_object = succes_class.new

      mock.expect :validate_call, nil
      mock.expect :nil?, false

      test_object = test_object.update do
        self.mock = mock
      end

      mock.verify
      refute_nil test_object
    end

    let :error_class do
      Class.new Pavlov::Entity do
        def validate
          raise @error_mock unless @error_mock.nil?
        end

        attributes :error_mock
      end
    end

    it 'calls validate after creating and throws when validations is not succesfull' do
      error = StandardError

      assert_raises error do
        test_object = error_class.new do
          self.error_mock = error
        end
      end
    end

    it 'calls validate after update and throws when validations is not succesfull' do
      error = StandardError
      test_object = error_class.new

      assert_raises error do
        test_object = test_object.update do
          self.error_mock = error
        end
      end
    end
  end

  describe '.update' do
    let('test_class') do
      Class.new Pavlov::Entity do
        attributes :name, :test

        private
        def private_method
          puts 'I''m private'
        end
      end
    end

    let 'helper_method' do
      'I''m a helper method for testing purposes.'
    end

    let 'default_name' do
      'This is your name.'
    end

    it 'must update a attribute' do
      test_object = test_class.new

      test_object = test_object.update do
        self.name = default_name
      end

      assert_equal default_name, test_object.name
    end

    it 'must partially update a entity' do
      test_object = test_class.new do
        self.test = default_name
      end

      other_name = 'I won''t tell you my name'
      test_object = test_object.update do
        self.name = other_name
      end

      assert_equal default_name, test_object.test
      assert_equal other_name, test_object.name
    end

    it 'must return an other object' do
      test_object = test_class.new

      updated_test_object = test_object.update

      refute_equal test_object.object_id, updated_test_object.object_id
    end

    it 'must set the attribute to the value of a local method' do
      test_object = test_class.new

      test_object = test_object.update do
        self.name = helper_method
      end

      assert_equal helper_method, test_object.name
    end

    it 'must not allow calling private methods' do
      test_object = test_class.new

      assert_raises(NoMethodError) {
        test_object.update do
          self.private_method
        end
      }
    end
  end

  describe 'immutability' do
    let('test_class') do
      Class.new Pavlov::Entity do
        attributes :name
      end
    end

    it 'must not be able to mutate entity' do
      test_object = test_class.new

      exception = assert_raises(RuntimeError) {
        test_object.name = 'bla'
      }
      assert_equal "This entity is immutable, please use 'instance = .new do; self.attribute = 'value'; end' or 'instance = instance.update do; self.attribute = 'value'; end'.",
        exception.message
    end
  end

  describe 'default behaviour' do
    let('test_class') do
      Class.new Pavlov::Entity
    end

    it 'must raise normally when calling a undefined method' do
      test_object = test_class.new

      exception = assert_raises(NoMethodError) {
        test_object.method_is_not_there
      }

      # todo: this exception is not thrown at the placet where I want it to, therefor the error message is a bit off
      # assert_match /undefined method `method_is_not_there' for #<Class:.*/, exception.message
      assert_match(/undefined method `method_is_not_there' for #<#<Class:.*/, exception.message)
    end
  end
end
