require_relative '../spec_helper'
require 'pavlov/interactor'

describe Pavlov::Interactor do
  let 'interactor_without_authorized?' do
    Class.new do
      include Pavlov::Interactor
    end
  end

  it "raises an error when .authorized? does not exist" do
    expect {
      interactor_without_authorized?.new.call
    }.to raise_error(NotImplementedError)
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

  it "raises an error when private .authorized? returns false" do
    expect {
      interactor_with_private_authorized?.new.call
    }.to raise_error(Pavlov::AccessDenied)
  end
end
