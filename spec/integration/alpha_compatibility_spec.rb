require_relative '../spec_helper'
require 'pavlov'
require 'pavlov/alpha_compatibility'

describe "Pavlov Alpha Compatibility" do
  before do
    stub_const "Queries",     Module.new
    stub_const "Commands",    Module.new
    stub_const "Interactors", Module.new

    module Interactors
      class OldStyleInteractor
        include Pavlov::Interactor

        arguments :title, :published

        private

        def authorized?
          pavlov_options[:current_user].name == "John"
        end

        def execute
          if published
            title.upcase!
          else
            title
          end
        end
      end
    end
  end

  include Pavlov::Helpers

  let(:user) { double(name: "John") }

  def pavlov_options
    {current_user: user}
  end

  it 'supports old-style arguments definition' do
    expect(interactor(:old_style_interactor, 'foo', true)).to eq('FOO')
  end

  it 'passes the pavlov_options' do
    user.stub(name: 'David')
    expect {
      interactor(:old_style_interactor, 'foo', true)
    }.to raise_error(Pavlov::AccessDenied)
  end
end
