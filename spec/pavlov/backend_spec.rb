require 'spec_helper'
require 'pavlov/backend'

describe Pavlov::Backend do
  let(:backend) { Pavlov::Backend.new }
  let(:finder)  { double }

  describe '#queries' do
    it 'returns a query finder' do
      Pavlov::OperationFinder.stub(:new).with("Queries", backend, true).and_return(finder)
      expect(backend.queries).to eq(finder)
    end
  end

  describe '#commands' do
    it 'returns a command finder' do
      Pavlov::OperationFinder.stub(:new).with("Commands", backend, true).and_return(finder)
      expect(backend.commands).to eq(finder)
    end
  end

  describe '#interactors' do
    it 'returns a query finder' do
      Pavlov::OperationFinder.stub(:new).with("Interactors", backend, false).and_return(finder)
      expect(backend.interactors).to eq(finder)
    end
  end
end
