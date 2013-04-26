require 'minitest/autorun'
require_relative '../test_helper'
require_relative '../../lib/pavlov.rb'

describe Pavlov::Helpers do
  describe 'interactor' do
    it 'calls an interactor whithout pavlov_options' do
      dummy_class = Class.new do
        include Pavlov::Helpers

        def test
          interactor :interactor_name, 'argument1', 'argument2'
        end
      end
      instance = dummy_class.new
      mock = MiniTest::Mock.new

      original = Pavlov.send(:const_get, :Pavlov)
      Pavlov.send(:const_set, :Pavlov, mock)

      mock.expect :interactor, nil, [:interactor_name, 'argument1', 'argument2']

      instance.test

      mock.verify
      Pavlov.send(:const_set, :Pavlov, original)
    end

    it 'calls an interactor with pavlov_options' do
      hash = {key:'value'}
      dummy_class = Class.new do
        include Pavlov::Helpers

        def pavlov_options
          {key:'value'}
        end

        def test
          interactor :interactor_name, 'argument1', 'argument2'
        end
      end
      instance = dummy_class.new
      mock = MiniTest::Mock.new
      original = Pavlov.send(:const_get, :Pavlov)
      Pavlov.send(:const_set, :Pavlov, mock)

      mock.expect :interactor, nil, [:interactor_name, 'argument1', 'argument2', hash]

      instance.test

      mock.verify
      Pavlov.send(:const_set, :Pavlov, original)
    end
  end
end
