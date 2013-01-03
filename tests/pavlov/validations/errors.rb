require 'minitest/autorun'

require_relative '../../../lib/pavlov/validations/errors'

describe Pavlov::Validations::Errors do
  it 'intitializes correctly' do
    klass = Class.new
    klass.send :include, Pavlov::Validations::Errors
    instance = klass.new
    instance
  end

  describe '.add' do
    let(:instance) do
      klass = Class.new
      klass.send :include, Pavlov::Validations::Errors
      klass.new
    end

    it 'an error with the attribute as a string' do
      test_attribute = 'bla'
      test_error_message = 'test'
      instance.add test_attribute, test_error_message
      number_of_errors = 0

      instance.each do |attribute, error_message|
        attribute.must_equal test_attribute
        error_message.must_equal test_error_message
        number_of_errors +=1
      end

      number_of_errors.must_equal 1
    end

    it 'an error with the attribute as a symbol' do
      test_attribute = 'bla'
      test_error_message = 'test'
      instance.add test_attribute.to_sym, test_error_message
      number_of_errors = 0

      instance.each do |attribute, error_message|
        attribute.must_equal test_attribute
        error_message.must_equal test_error_message
        number_of_errors +=1
      end

      number_of_errors.must_equal 1
    end
  end

  describe '.each' do
    let(:instance) do
      klass = Class.new
      klass.send :include, Pavlov::Validations::Errors
      klass.new
    end

    it 'returns nothing when empty' do
      number_of_errors = 0

      instance.each do |attribute, error_message|
        number_of_errors +=1
      end

      number_of_errors.must_equal 0
    end

    it 'returns one item' do
      test_attribute = 'test1'
      test_error_message = 'messsage1'
      instance.add(test_attribute, test_error_message)

      number_of_errors = 0

      instance.each do |attribute, error_message|
        number_of_errors +=1
      end

      number_of_errors.must_equal 1
    end

    it 'returns two items fifo' do
      instance.add('test1','message1')
      instance.add('test2','message2')

      number_of_errors = 0

      instance.each do |attribute, error_message|
        attribute.must_equal 'test'+number_of_errors.to_s
        error_message.must_equal 'message'+number_of_errors.to_s
        number_of_errors +=1
      end

      number_of_errors.must_equal 2
    end
  end
end
