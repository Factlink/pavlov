require 'minitest/autorun'

require_relative '../../../lib/pavlov/helpers/safe_evaluator'

describe Pavlov::Helpers::SafeEvaluator do
  it 'inititializes correctly' do
    safe_evaluator = Pavlov::Helpers::SafeEvaluator.new MiniTest::Mock.new, MiniTest::Mock.new
    refute_equal nil, safe_evaluator
  end

  it 'pipes setter method calls to target_instance' do
    target_instance = MiniTest::Mock.new
    safe_evaluator = Pavlov::Helpers::SafeEvaluator.new target_instance, MiniTest::Mock.new

    target_instance.expect :public_send, nil,[:test=, true]

    safe_evaluator.test = true
  end

  it 'pipes getter method calls to caller_instance' do
    caller_instance = MiniTest::Mock.new
    safe_evaluator = Pavlov::Helpers::SafeEvaluator.new MiniTest::Mock.new, caller_instance

    caller_instance.expect :send, true,[:test, true]

    safe_evaluator.test true
  end
end
