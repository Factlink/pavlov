require 'minitest/autorun'
require_relative '../../lib/pavlov.rb'

describe Pavlov::Operation do

  describe '#initialize' do
    it "calls validate if it exists" do
      dummy_class = Class.new do
        include Pavlov::Operation
        def validate
          @x_val = :validate_was_called
        end
        def validate_was_called
          @x_val
        end
        def authorized?; true; end
      end
      x = dummy_class.new
      x.validate_was_called.must_equal :validate_was_called
    end

    it "calls check_authority" do
      dummy_class = Class.new do
        include Pavlov::Operation
        def check_authorization
          @was_check_authorization_called = :yes
        end
        def check_authorization_was_called
          @was_check_authorization_called
        end
        def authorized?; true; end
      end
      x = dummy_class.new
      x.check_authorization_was_called.must_equal :yes
    end
  end

  describe '.argument' do
    it 'defines an argument' do
      op = operation { argument :first }
      op.new(first: 'first argument').first.must_equal 'first argument'
    end

    it 'assigns a default value if given' do
      op = operation { argument :first, default: 'default value' }
      op.new(first: 'given value').first.must_equal 'given value'
      op.new.first.must_equal 'default value'
    end

    it 'raises when an argument without a default value is missing' do
      op = operation { argument :first }
      op.new(first: 'given value').first.must_equal 'given value'
      proc { op.new }.must_raise ArgumentError, "Missing argument: first"
    end

    it 'can have a default value that is nil' do
      op = operation { argument :first, default: nil }
      op.new.first.must_equal nil
    end

    it 'can have arguments passed that are nil' do
      op = operation { argument :first, default: 'default value' }
      op.new(first: nil).first.must_equal nil
    end
  end

  describe '.check_authority' do
    it "raises no error when .authorized? returns true" do
      dummy_class = Class.new do
        include Pavlov::Operation
        def authorized?
          true
        end
      end
      dummy_class.new # wont_raise
    end

    it "raises an error when .authorized? returns false" do
      dummy_class = Class.new do
        include Pavlov::Operation
        def authorized?
          false
        end
      end
      -> {dummy_class.new}.must_raise Pavlov::AccessDenied
    end
  end

  def operation(&block)
    Class.new { include Pavlov::Operation }.tap do |operation_class|
      operation_class.instance_eval &block
    end
  end
end
