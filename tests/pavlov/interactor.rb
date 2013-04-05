require 'minitest/autorun'
require_relative '../test_helper'
require_relative '../../lib/pavlov.rb'

describe Pavlov::Interactor do
  it 'should have a class which has a queue method which returns a default queue' do
    i = Class.new

    i.send(:include, Pavlov::Interactor)

    i.queue.must_equal :interactor_operations
  end
end
