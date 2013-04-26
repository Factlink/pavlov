require 'minitest/autorun'
require_relative '../test_helper'
require_relative '../../lib/pavlov.rb'

describe Pavlov::Operation do

  describe '#arguments' do
    describe "creates an initializer which" do
      it "saves arguments passed to instance variables" do
        dummy_class = Class.new do
          include Pavlov::Operation
          arguments :first_argument
          def authorized?; true; end
        end

        x = dummy_class.new 'argument'
        x.send(:instance_variable_get,'@first_argument').must_equal 'argument'
      end

      it "saves arguments passed to instance variables in order" do
        dummy_class = Class.new do
          include Pavlov::Operation
          arguments :var1, :var2
          def authorized?; true; end
        end

        x = dummy_class.new 'VAR1', 'VAR2'
        x.send(:instance_variable_get,'@var1').must_equal 'VAR1'
        x.send(:instance_variable_get,'@var2').must_equal 'VAR2'
      end

      it "calls validate if it exists" do
        dummy_class = Class.new do
          include Pavlov::Operation
          arguments
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
          arguments
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

    it 'creates attribute readers' do
      dummy_class = Class.new do
        include Pavlov::Operation
        arguments :foo
        def authorized?; true; end
      end
      x = dummy_class.new 'value for foo'
      x.foo.must_equal 'value for foo'
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
end
