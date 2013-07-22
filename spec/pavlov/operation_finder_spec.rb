require 'spec_helper'
require 'pavlov/operation_finder'

describe Pavlov::OperationFinder do
  let(:operation) { double }

  it 'finds operations inside a single namespace' do
    stub_const "Interactors::Foo", operation
    finder = Pavlov::OperationFinder.new("Interactors")
    expect(finder.find(:foo)).to eq(operation)
  end

  it 'does not find operations outside namespace' do
    stub_const "Outeractors::Foo", operation
    finder = Pavlov::OperationFinder.new("Interactors")
    expect { finder.find(:foo) }.to raise_error(NameError)
  end
end
