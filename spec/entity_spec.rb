require 'spec_helper'

require 'pavlov/entity'

describe Pavlov::Entity do
  let 'test_class' do
    Class.new Pavlov::Entity do
      attributes :name, :test
    end
  end

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

      expect( test_object ).to_not be_nil
    end

    it 'must return the correct class' do
      test_object = test_class.new

      expect( test_object.class ).to equal test_class
    end

    it 'must set the attribute when given a block' do
      test_object = test_class.new do
        self.name = default_name
      end

      expect( test_object.name ).to equal default_name
    end

    it 'must set the attribute when given a hash' do
      test_object = test_class.new({name: default_name})

      expect( test_object.name ).to equal default_name
    end

    it 'must set the attribut to the value of a local method' do
      test_object = test_class.new do
        self.name = helper_method
      end

      expect( test_object.name ).to equal helper_method
    end

    it 'must not allow to call private methods' do
      expect {
        test_class.new do
          self.private_method
        end
      }.to raise_error(NoMethodError)
    end

    it 'must be able to set two attributes when given a block' do
      test_value = false

      test_object = test_class.new do
        self.name = default_name
        self.test = test_value
      end

      expect( test_object.name ).to equal default_name
      expect( test_object.test ).to equal test_value
    end

    it 'must be able to set two attributes when given a hash' do
      test_value = false

      test_object = test_class.new({name: default_name, test: test_value})

      expect( test_object.name ).to equal default_name
      expect( test_object.test ).to equal test_value
    end

    it 'must be able to set two attributes when given two arguments' do
      test_value = false

      test_object = test_class.new(default_name, test_value)

      expect( test_object.name ).to equal default_name
      expect( test_object.test ).to equal test_value
    end

    it 'gives precedence to the block when given a hash and a block' do
      test_value = false

      test_object = test_class.new({name: 'string that is overwritten', test: true}) do
        self.name = default_name
        self.test = test_value
      end

      expect( test_object.name ).to equal default_name
      expect( test_object.test ).to equal test_value
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

      expect( test_object.name ).to equal default_name
    end

    it 'must partially update a entity' do
      test_object = test_class.new do
        self.test = default_name
      end

      other_name = 'I won''t tell you my name'
      test_object = test_object.update do
        self.name = other_name
      end

      expect( test_object.test ).to equal default_name
      expect( test_object.name ).to equal other_name
    end

    it 'must set the attribute to the value of a local method' do
      test_object = test_class.new

      test_object = test_object.update do
        self.name = helper_method
      end

      expect( test_object.name ).to equal helper_method
    end

    it 'must not allow calling private methods' do
      test_object = test_class.new

      expect {
        test_object.update do
          self.private_method
        end
      }.to raise_error(NoMethodError)
    end
  end

  describe 'default behaviour' do
    let('test_class') do
      Class.new Pavlov::Entity
    end

    it 'must raise normally when calling a undefined method' do
      test_object = test_class.new

      # todo: this exception is not thrown at the placet where I want it to, therefor the error message is a bit off
      # assert_match /undefined method `method_is_not_there' for #<Class:.*/, exception.message
      expect {
        test_object.method_is_not_there
      }.to raise_error(NoMethodError, /undefined method `method_is_not_there'/) 
    end
  end

  describe '#valid?' do
    let('test_class_no_validations') do
      Class.new Pavlov::Entity do
        attributes :name
      end
    end

    let('test_class_with_validations') do
      Class.new Pavlov::Entity do
        def self.name
          'TestClassWithValidations'
        end

        validates_presence_of :test_attribute

        attributes :test_attribute
      end
    end

    it 'succeeds without validation rules' do
      test_object = test_class_no_validations.new

      expect( test_object.valid? ).to equal true
    end

    it 'fails with validation rules which are not met' do
      test_object = test_class_with_validations.new

      expect( test_object.valid? ).to equal false
    end
  end
end
