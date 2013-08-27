require_relative '../spec_helper'
require 'pavlov/command'

describe Pavlov::Command do
  let 'command_with_private_authorized?' do
    Class.new do
      include Pavlov::Command

      private

      def authorized?
        false
      end
    end
  end

  it 'raises an error when private .authorized? returns false' do
    expect do
      command_with_private_authorized?.new.call
    end.to raise_error(Pavlov::AccessDenied)
  end

  let :simple_command do
    Class.new do
      include Pavlov::Command

      private

      def execute
        :executed
      end
    end
  end

  it 'executes without checking authorized or validate' do
    expect(simple_command.new.call).to eq :executed
  end
end
