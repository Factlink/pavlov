require 'minitest/autorun'

require_relative '../../lib/pavlov/immutable_entity'

describe Pavlov::ImmutableEntity do

  describe '#update' do
    let('test_class') do
      Class.new Pavlov::ImmutableEntity do
        attributes :name, :test

        private
        def private_method
          puts 'I''m private'
        end
      end
    end

    it 'must return an new instance' do
      test_object = test_class.new

      updated_test_object = test_object.update

      updated_test_object.object_id.wont_equal test_object.object_id
    end
  end

  describe 'immutability' do
    let('test_class') do
      Class.new Pavlov::ImmutableEntity do
        attributes :name
      end
    end

    it 'must not be able to mutate entity' do
      test_object = test_class.new

      exception = assert_raises(RuntimeError) {
        test_object.name = 'bla'
      }

      exception.message.must_equal "This entity is immutable, please use 'instance = .new do; self.attribute = 'value'; end' or 'instance = instance.update do; self.attribute = 'value'; end'."
    end

    let :succes_class do
      Class.new Pavlov::ImmutableEntity do
        def initialize
          @validation_mock ||= nil
        end

        def valid?
          @validation_mock.validate_call unless @validation_mock.nil?
        end

        attributes :validation_mock
      end
    end

    it 'calls valid? after creating and returns the entity when validations is succesfull' do
      mock = MiniTest::Mock.new

      mock.expect :validate_call, nil
      mock.expect :nil?, false

      test_object = succes_class.new do
        self.validation_mock = mock
      end

      mock.verify
      test_object.wont_be_nil
    end

    it 'calls valid? after update and returns the entity when validations is succesfull' do
      mock = MiniTest::Mock.new
      test_object = succes_class.new

      mock.expect :validate_call, nil
      mock.expect :nil?, false

      test_object = test_object.update do
        self.validation_mock = mock
      end

      mock.verify
      test_object.wont_be_nil
    end

    let :error_class do
      Class.new Pavlov::ImmutableEntity do
        def initialize
          @error ||= nil
        end

        def valid?  
          raise @error unless @error.nil?
        end

        attributes :error
      end
    end

    it 'calls validate after creating and throws when validations is not succesfull' do
      error = StandardError

      assert_raises error do
        error_class.new do
          self.error = error
        end
      end
    end

    it 'calls validate after update and throws when validations is not succesfull' do
      error = StandardError
      test_object = error_class.new

      assert_raises error do
        test_object = test_object.update do
          self.error = error
        end
      end
    end
  end
end
