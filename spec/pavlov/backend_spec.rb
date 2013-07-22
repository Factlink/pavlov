require 'spec_helper'
require 'pavlov/backend'

describe Pavlov::Backend do
  let(:operation_instance) { double }
  let(:operation)          { double(new: operation_instance) }
  let(:backend) { Pavlov::Backend.new }

  describe '#interactor' do
    before { stub_const("Interactors::Foo", operation) }

    it 'finds interactors' do
      expect(backend.interactor(:foo)).to eq(operation_instance)
    end

    it 'passes itself as backend-attribute to interactor' do
      backend.interactor(:foo)
      expect(operation).to have_received(:new).with(backend: backend)
    end
  end

  describe '#command' do
    before { stub_const("Commands::Foo", operation) }

    it 'finds commands' do
      expect(backend.command(:foo)).to eq(operation_instance)
    end

    it 'passes itself as backend-attribute to command' do
      backend.command(:foo)
      expect(operation).to have_received(:new).with(backend: backend)
    end
  end

  describe '#query' do
    before { stub_const("Queries::Foo", operation) }

    it 'finds queries' do
      expect(backend.query(:foo)).to eq(operation_instance)
    end

    it 'passes itself as backend-attribute to query' do
      backend.query(:foo)
      expect(operation).to have_received(:new).with(backend: backend)
    end
  end
end
