require_relative '../spec_helper'
require 'pavlov/command'

describe Pavlov::Command do  
  describe '#call' do
    let 'command_with_private_authorized?' do
      Class.new do
        include Pavlov::Command

        private
        def authorized?
          false
        end
      end
    end

    it "raises an error when private .authorized? returns false" do
      command = command_with_private_authorized?.new

      expect do
        command.call
      end.to raise_error(Pavlov::AccessDenied)
    end
  end
end
