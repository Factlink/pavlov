require_relative '../spec_helper'
require 'pavlov/interactor'

describe Pavlov::Interactor do
  let 'interactor_without_authorized?' do
    Class.new do
      include Pavlov::Interactor
    end
  end

  it 'raises an error when .authorized? does not exist' do
    expect do
      interactor_without_authorized?.new.call
    end.to raise_error
  end

  let 'interactor_with_private_authorized?' do
    Class.new do
      include Pavlov::Interactor

      private

      def authorized?
        false
      end
    end
  end

  it 'raises an error when private .authorized? returns false' do
    expect do
      interactor_with_private_authorized?.new.call
    end.to raise_error(Pavlov::AccessDenied)
  end

  let :simple_interactor do
    Class.new do
      include Pavlov::Interactor

      private

      def authorized?
        true
      end

      def execute
        :executed
      end
    end
  end

  it 'executes without exceptions when authorized, without validations defined' do
    expect(simple_interactor.new.call).to eq :executed
  end
end
