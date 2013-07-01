require_relative 'spec_helper'
require 'pavlov/operation'

describe Pavlov::Operation do

  describe '#arguments' do
    describe "creates an initializer which" do
      it "saves arguments and retrieve via getter" do
        dummy_class = Class.new do
          include Pavlov::Operation
          arguments :first_argument
          def authorized?; true; end
        end

        operation = dummy_class.new 'argument'

        expect( operation.first_argument ).to eq 'argument'
      end

      it "saves arguments and retrieves them via getters" do
        dummy_class = Class.new do
          include Pavlov::Operation
          arguments :var1, :var2
          def authorized?; true; end
        end

        operation = dummy_class.new 'VAR1', 'VAR2'

        expect( operation.var1 ).to eq 'VAR1'
        expect( operation.var2 ).to eq 'VAR2'
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
        operation = dummy_class.new
        expect( operation.validate_was_called ).to equal :validate_was_called
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
        operation = dummy_class.new

        expect( operation.check_authorization_was_called ).to equal :yes
      end
    end
  end

  describe '.check_authority' do
    before do
      stub_const 'Pavlov::AccessDenied', StandardError
    end

    it "raises no error when .authorized? returns true" do
      dummy_class = Class.new do
        include Pavlov::Operation
        def authorized?
          true
        end
      end
      expect {
        dummy_class.new 
      }.to_not raise_error
    end

    it "raises an error when .authorized? returns false" do
      dummy_class = Class.new do
        include Pavlov::Operation
        def authorized?
          false
        end
      end
      expect {
        dummy_class.new
      }.to raise_error Pavlov::AccessDenied
    end
  end
end
