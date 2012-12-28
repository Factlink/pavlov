require 'minitest/autorun'

require_relative '../../../lib/pavlov/validations/errors'

describe Pavlov::Validations::Errors do
  it 'intitializes correctly' do
    instance = Pavlov::Validations::Errors.new
    refute_nil instance
  end

  describe '.add' do
    it 'an error with the attribute as a string' do
      instance = Pavlov::Validations::Errors.new
      test_attribute = 'bla'
      test_error_message = 'test'
      instance.add test_attribute, test_error_message
      number_of_errors = 0

      instance.each do |attribute, error_message|
        assert_equal test_attribute, attribute
        assert_equal test_error_message, error_message
        number_of_errors +=1
      end

      assert_equal 1, number_of_errors
    end

    it 'an error with the attribute as a symbol' do
      instance = Pavlov::Validations::Errors.new
      test_attribute = 'bla'
      test_error_message = 'test'
      instance.add test_attribute.to_sym, test_error_message
      number_of_errors = 0

      instance.each do |attribute, error_message|
        assert_equal test_attribute, attribute
        assert_equal test_error_message, error_message
        number_of_errors +=1
      end

      assert_equal 1, number_of_errors
    end
  end

  describe '.each' do
    it 'returns nothing when empty' do
      instance = Pavlov::Validations::Errors.new
      number_of_errors = 0

      instance.each do |attribute, error_message|
        number_of_errors +=1
      end

      assert_equal 0, number_of_errors
    end

    it 'returns one item' do
      instance = Pavlov::Validations::Errors.new
      test_attribute = 'test1'
      test_error_message = 'messsage1'
      instance.add(test_attribute, test_error_message)

      number_of_errors = 0

      instance.each do |attribute, error_message|
        number_of_errors +=1
      end

      assert_equal 1, number_of_errors
    end

    it 'returns two items fifo' do
      instance = Pavlov::Validations::Errors.new
      instance.add('test1','message1')
      instance.add('test2','message2')
      
      number_of_errors = 0

      instance.each do |attribute, error_message|
        number_of_errors +=1
        assert_equal 'test'+number_of_errors.to_s, attribute 
        assert_equal 'message'+number_of_errors.to_s, error_message
      end

      assert_equal 2, number_of_errors
    end
  end
end