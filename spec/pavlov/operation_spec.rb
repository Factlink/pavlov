require_relative '../spec_helper'
require 'pavlov/operation'

describe Pavlov::Operation do

  describe '#arguments' do
    describe "creates an initializer which" do
      it "saves arguments and retrieve via getter" do
        dummy_class = Class.new do
          include Pavlov::Operation
          attribute :first_argument, String
        end

        operation = dummy_class.new first_argument: 'argument'

        expect( operation.first_argument ).to eq 'argument'
      end

      it "saves arguments and retrieves them via getters" do
        dummy_class = Class.new do
          include Pavlov::Operation
          attribute :var1, String
          attribute :var2, String
        end

        operation = dummy_class.new var1: 'VAR1', var2: 'VAR2'

        expect( operation.var1 ).to eq 'VAR1'
        expect( operation.var2 ).to eq 'VAR2'
      end
    end
  end

  describe '#call' do
    let(:dummy_class) do
      Class.new do
        include Pavlov::Operation
        attribute :validation_check,    Object
        attribute :authorization_check, Object
        def validate; validation_check.call; end
        def authorized?; authorization_check.call; end
        def execute; end
      end
    end

    let(:validation_check)    { double(call: true) }
    let(:authorization_check) { double(call: true) }
    let(:operation) { dummy_class.new(validation_check: validation_check,
                                      authorization_check: authorization_check) }

    it "calls validate if it exists" do
      operation.call
      expect(validation_check).to have_received(:call).once
    end

    it "calls check_authority" do
      operation.call
      expect(authorization_check).to have_received(:call).once
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
        def execute; end
      end
      expect {
        dummy_class.new.call
      }.to_not raise_error
    end

    it "raises an error when .authorized? returns false" do
      dummy_class = Class.new do
        include Pavlov::Operation
        def authorized?
          false
        end
        def execute; end
      end
      expect {
        dummy_class.new.call
      }.to raise_error Pavlov::AccessDenied
    end
  end
end
