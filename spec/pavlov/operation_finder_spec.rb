require 'spec_helper'
require 'pavlov/operation_finder'

describe Pavlov::OperationFinder do
  let(:instance)  { double("instance") }
  let(:operation) { double("operation", new: instance) }
  let(:backend)   { double("backend") }

  it 'finds operations inside a single namespace' do
    stub_const "Interactors::Foo", operation
    finder = Pavlov::OperationFinder.new("Interactors", backend)
    expect(finder.foo).to eq(instance)
  end

  it 'does not find operations outside namespace' do
    stub_const "Outeractors::Foo", operation
    finder = Pavlov::OperationFinder.new("Interactors", backend)
    expect { finder.foo }.to raise_error(NameError)
  end
end
