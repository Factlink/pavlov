require 'spec_helper'
require 'pavlov/backend'

describe Pavlov::Backend do
  let(:operation_result)   { double('operation result') }
  let(:operation_instance) { double('operation instance', call: operation_result) }
  let(:operation)          { double('operation class', new: operation_instance) }
  let(:backend)            { Pavlov::Backend.new }

  before do
    stub_const 'Queries', Module.new
    stub_const 'Commands', Module.new
    stub_const 'Interactors', Module.new
  end

  it 'stores pavlov_options' do
    pavlov_options = double('Pavlov Options')
    backend = Pavlov::Backend.new(pavlov_options: pavlov_options)
    expect(backend.pavlov_options).to eq(pavlov_options)
  end

  describe '#interactor' do
    before do
      Pavlov::OperationFinder.stub(:find).with(Interactors, :foo).and_return(operation)
    end

    it 'finds interactors' do
      expect(backend.interactor(:foo)).to eq(operation_result)
    end

    it 'passes itself as backend-attribute to interactor' do
      backend.interactor(:foo)
      expect(operation).to have_received(:new).with(backend: backend)
    end
  end

  describe '#command' do
    before do
      Pavlov::OperationFinder.stub(:find).with(Commands, :foo).and_return(operation)
    end

    it 'finds commands' do
      expect(backend.command(:foo)).to eq(operation_result)
    end

    it 'passes itself as backend-attribute to command' do
      backend.command(:foo)
      expect(operation).to have_received(:new).with(backend: backend)
    end
  end

  describe '#query' do
    before do
      Pavlov::OperationFinder.stub(:find).with(Queries, :foo).and_return(operation)
    end

    it 'finds queries' do
      expect(backend.query(:foo)).to eq(operation_result)
    end

    it 'passes itself as backend-attribute to query' do
      backend.query(:foo)
      expect(operation).to have_received(:new).with(backend: backend)
    end
  end
end
