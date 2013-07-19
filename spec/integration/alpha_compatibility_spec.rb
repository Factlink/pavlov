require_relative '../spec_helper'
require 'pavlov'
require 'pavlov/alpha_compatibility'

describe "Pavlov Alpha Compatibility" do
  include Pavlov::Helpers

  describe 'retains .arguments' do
    before do
      stub_const "Interactors", Module.new

      class Interactors::OldStyleInteractor
        include Pavlov::Interactor
        arguments :title, :published

        def authorized?
          true
        end

        def execute
          published ? title.upcase! : title
        end
      end
    end

    it 'supports old-style arguments definition' do
      expect(interactor(:old_style_interactor, 'foo', false)).to eq('foo')
      expect(interactor(:old_style_interactor, 'foo', true)).to eq('FOO')
    end
  end

  describe 'retains pavlov_options' do
    let(:current_user) { double("User", name: "John") }
    def pavlov_options
      {current_user: current_user}
    end

    before do
      stub_const "Queries", Module.new
      stub_const "Interactors", Module.new
      class Queries::FindUppercaseName
        include Pavlov::Query
        arguments
        def execute
          pavlov_options[:current_user].name.upcase
        end
      end

      class Interactors::ShoutyGreeting
        include Pavlov::Interactor
        arguments
        def authorized?; true; end
        def execute
          "OHAI, #{query :find_uppercase_name}"
        end
      end
    end

    it 'passes the pavlov_options from operation to operation' do
      expect(interactor :shouty_greeting).to eq("OHAI, JOHN")
    end
  end
end