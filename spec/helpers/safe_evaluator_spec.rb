require_relative '../spec_helper'
require 'pavlov'

describe Pavlov::Helpers::SafeEvaluator do
  it 'inititializes correctly' do
    safe_evaluator = Pavlov::Helpers::SafeEvaluator.new mock, mock
    
    expect(safe_evaluator).to_not be_nil
  end

  it 'pipes setter method calls to target_instance' do
    target_instance = mock
    safe_evaluator = Pavlov::Helpers::SafeEvaluator.new target_instance, mock

    target_instance.should_receive(:public_send)
      .with(:test=, true)

    safe_evaluator.test = true
  end

  it 'pipes getter method calls to caller_instance' do
    caller_instance = mock
    safe_evaluator = Pavlov::Helpers::SafeEvaluator.new mock, caller_instance

    caller_instance.should_receive(:send)
      .with(:test, true)

    safe_evaluator.test true
  end
end
