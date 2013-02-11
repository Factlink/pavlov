require 'minitest/autorun'

require_relative '../../lib/pavlov/model'

describe Pavlov::Model do
  let 'test_class' do
    Class.new Pavlov::Model do
      attributes :name, :test
    end
  end

  it 'initializes' do
    model = test_class.new

    model.wont_be_nil
  end

  describe '#valid?' do
    let('test_class_no_validations') do
      Class.new Pavlov::Model do
        attributes :name
      end
    end

    let('test_class_with_validations') do
      Class.new Pavlov::Model do
        def self.name
          'TestClassWithValidations'
        end

        validates_presence_of :test_attribute

        attributes :test_attribute
      end
    end

    it 'succeeds without validation rules' do
      test_object = test_class_no_validations.new

      test_object.valid?.must_equal true
    end

    it 'fails with validation rules which are not met' do
      test_object = test_class_with_validations.new

      test_object.valid?.must_equal false
    end
  end
end