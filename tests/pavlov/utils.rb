require 'minitest/autorun'
require_relative '../../lib/pavlov.rb'

describe Pavlov::Utils do
  let(:instance) { Object.new.extend Pavlov::Utils }

  describe :hash_with_index do
    it "wraps its input in a hash, with as index the id of the objects in the array" do

      klass = Struct.new(:id)
      stub1 = klass.new 1
      stub2 = klass.new 2
      stublist = [stub1, stub2]

      wrapped_stub_list = {
        1 => stublist[0],
        2 => stublist[1]
      }

      result = instance.hash_with_index(:id, stublist)
      result.must_equal wrapped_stub_list
    end
  end
end
