require 'spec_helper'
require 'pavlov/operation_finder'

describe Pavlov::OperationFinder do
  let(:operation) { Class.new }

  it 'finds operations based on given string' do
    stub_const 'Commands::FindUser', operation
    result = Pavlov::OperationFinder.find(Commands, 'find_user')
    expect(result).to eq(operation)
  end

  it 'finds nested operations based on given string' do
    stub_const 'Commands::User::ById', operation
    result = Pavlov::OperationFinder.find(Commands, 'user/by_id')
    expect(result).to eq(operation)
  end
end
