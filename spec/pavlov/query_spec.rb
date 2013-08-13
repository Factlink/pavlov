require_relative '../spec_helper'
require 'pavlov/query'

describe Pavlov::Query do
  let 'qeury_with_private_authorized?' do
    Class.new do
      include Pavlov::Query

      private
      def authorized?
        false
      end
    end
  end

  it 'raises an error when private .authorized? does not exist' do
    expect do
      qeury_with_private_authorized?.new.call
    end.to raise_error(Pavlov::AccessDenied)
  end

  let :simple_query do
    Class.new do
      include Pavlov::Query

      private
      def execute
        :executed
      end
    end
  end

  it 'executes without checking authorized or validate' do
    expect(simple_query.new.call).to eq :executed
  end
end
