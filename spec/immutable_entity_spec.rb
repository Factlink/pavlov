require_relative 'spec_helper'
require 'pavlov/immutable_entity'

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

      expect( updated_test_object.object_id ).to_not equal test_object.object_id
    end
  end

  describe 'immutability' do
    before do
      stub_const "Pavlov::Errors::Immutable", StandardError
    end

    let('test_class') do
      Class.new Pavlov::ImmutableEntity do
        attributes :name
      end
    end

    it 'must not be able to mutate entity' do
      test_object = test_class.new

      expect {
        test_object.name = 'bla'
      }.to raise_error(RuntimeError, "This entity is immutable, please use 'instance = .new do; self.attribute = 'value'; end' or 'instance = instance.update do; self.attribute = 'value'; end'.")
    end

    it 'calls valid? after creating and returns the entity when validations is succesfull' do
      test_object = described_class.new 

      expect( test_object ).to_not be_nil
    end

    it 'calls valid? after update and returns the entity when validations is succesfull' do
      test_object = described_class.new

      test_object = test_object.update

      expect( test_object ).to_not be_nil
    end

    it 'calls validate after creating and throws when validations is not succesfull' do
      described_class.any_instance.should_receive(:valid?).and_return(false)

      expect {
        described_class.new 
      }.to raise_error(Pavlov::Errors::Immutable)
    end

    it 'calls validate after update and throws when validations is not succesfull' do
      test_object = described_class.new

      described_class.any_instance.should_receive(:valid?).and_return(false)

      expect {
        test_object = test_object.update
      }.to raise_error(Pavlov::Errors::Immutable)
    end
  end
end
