require_relative '../spec_helper'
require 'pavlov/interactor'

describe Pavlov::Interactor do
  let 'test_class' do
    Class.new do
      include Pavlov::Interactor

      def authorized?
        true
      end
    end
  end

  let 'test_class_without_authorized?' do
    Class.new do
      include Pavlov::Interactor
    end
  end

  it "raises an error when .authorized? does not exist" do
    expect {
      test_class_without_authorized?.new
    }.to raise_error(NotImplementedError)
  end
end
