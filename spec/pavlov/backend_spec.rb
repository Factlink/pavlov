require 'spec_helper'
require 'pavlov/backend'

describe Pavlov::Backend do
  let(:operation_instance) { double }
  let(:operation)          { double(new: operation_instance) }
  let(:backend)            { Pavlov::Backend.new }
  let(:finder)             { double.tap {|f| f.stub(:find).with(:foo).and_return(operation) } }

  describe '#interactor' do
    before do
      Pavlov::OperationFinder.stub(:new).with("Interactors").and_return(finder)
    end

    it 'finds interactors' do
      expect(backend.interactor(:foo)).to eq(operation_instance)
    end

    it 'passes itself as backend-attribute to interactor' do
      backend.interactor(:foo)
      expect(operation).to have_received(:new).with(backend: backend)
    end
  end

  describe '#command' do
    before do
      Pavlov::OperationFinder.stub(:new).with("Commands").and_return(finder)
    end

    it 'finds commands' do
      expect(backend.command(:foo)).to eq(operation_instance)
    end

    it 'passes itself as backend-attribute to command' do
      backend.command(:foo)
      expect(operation).to have_received(:new).with(backend: backend)
    end
  end

  describe '#query' do
    before do
      Pavlov::OperationFinder.stub(:new).with("Queries").and_return(finder)
    end

    it 'finds queries' do
      expect(backend.query(:foo)).to eq(operation_instance)
    end

    it 'passes itself as backend-attribute to query' do
      backend.query(:foo)
      expect(operation).to have_received(:new).with(backend: backend)
    end
  end
end
