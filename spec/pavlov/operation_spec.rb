require_relative '../spec_helper'
require 'pavlov/operation'

describe Pavlov::Operation do

  describe '#call' do
    let(:dummy_class) do
      Class.new do
        include Pavlov::Operation
        attribute :validation_check,    Object
        attribute :authorization_check, Object

        def valid?
          validation_check.call
        end

        def authorized?
          authorization_check.call
        end

        def execute
        end
      end
    end

    let(:validation_check)    { double(call: true) }
    let(:authorization_check) { double(call: true) }
    let(:operation) do
      dummy_class.new validation_check: validation_check,
                      authorization_check: authorization_check
    end

    it 'calls validate if it exists' do
      operation.call
      expect(validation_check).to have_received(:call).once
    end

    it 'calls check_authority' do
      operation.call
      expect(authorization_check).to have_received(:call).once
    end

    it 'raises ValidationError when not valid' do
      validation_check.stub(call: false)
      expect { operation.call }.to raise_error(Pavlov::ValidationError)
    end

    it 'raises ValidationError when not valid' do
      authorization_check.stub(call: false)
      expect { operation.call }.to raise_error(Pavlov::AccessDenied)
    end
  end

  describe 'validations' do
    describe 'check if attributes without defaults have were given a value' do
      it 'passes when given a value' do
        dummy_class = Class.new do
          include Pavlov::Operation
          attribute :title, String
        end
        expect(dummy_class.new(title: 'Title').validate).to be_true
      end

      it 'passes when given a default' do
        dummy_class = Class.new do
          include Pavlov::Operation
          attribute :title,   String, default: 'A title'
          attribute :date,    Time,   default: -> { Time.now }
          attribute :visible, String, default: nil
        end
        expect(dummy_class.new.validate).to be_true
      end

      it 'fails when not given a value' do
        dummy_class = Class.new do
          include Pavlov::Operation
          attribute :title, String
        end
        expect(dummy_class.new.validate).to be_false
      end
    end
  end

  describe '.check_authority' do
    before do
      stub_const 'Pavlov::AccessDenied', StandardError
    end

    it 'raises no error when .authorized? returns true' do
      dummy_class = Class.new do
        include Pavlov::Operation
        def authorized?
          true
        end

        def execute
        end
      end
      expect do
        dummy_class.new.call
      end.to_not raise_error
    end

    it 'raises an error when .authorized? returns false' do
      dummy_class = Class.new do
        include Pavlov::Operation
        def authorized?
          false
        end

        def execute
        end
      end
      expect do
        dummy_class.new.call
      end.to raise_error Pavlov::AccessDenied
    end
  end
end
