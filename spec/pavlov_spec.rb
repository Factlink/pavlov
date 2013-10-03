require_relative 'spec_helper'
require 'pavlov'

module Commands end
module Interactors end
module Queries end

describe Pavlov do
  before do
    stub_const 'Pavlov::OperationFinder', Class.new
  end

  [{ type: 'command', namespace: Commands }, { type: 'query', namespace: Queries }, { type: 'interactor', namespace: Interactors }].each do |operation|
    type = operation[:type]
    namespace = operation[:namespace]

    it ".#{type} calls #call when no block is given" do
      args = [1, 2, 3, 4]
      command_name = :operation_name
      results = double
      klass = double
      instance = double
      allow(Pavlov::OperationFinder).to receive(:find).with(namespace, command_name).and_return(klass)
      allow(klass).to receive(:new).with(*args).and_return(instance)

      expect(instance).to receive(:call).and_return(results)

      expect(described_class.send(type.to_sym, command_name, *args)).to eq results
    end

    it ".#{type} returns interactor when block is given" do
      args = [1, 2, 3, 4]
      command_name = :operation_name
      klass = double
      instance = double
      allow(Pavlov::OperationFinder).to receive(:find).with(namespace, command_name).and_return(klass)
      allow(klass).to receive(:new).with(*args).and_return(instance)

      executed_block = false
      described_class.send(type.to_sym, command_name, *args) do |interaction|
        expect(interaction).to eq instance
        executed_block = true
      end

      expect(executed_block).to eq true
    end
  end
end
