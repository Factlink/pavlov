require_relative 'spec_helper'
require 'pavlov.rb'

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

      Pavlov.should_receive(:interactor)
        .with(:interactor_name, 'argument1', 'argument2')

      instance.test
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
      
      Pavlov.should_receive(:interactor)
        .with(:interactor_name, 'argument1', 'argument2', hash)

      instance.test
    end
  end
end
