require_relative '../spec_helper'
require 'pavlov'

describe 'Pavlov interactors' do
  before do
    stub_const 'Queries', Module.new
    class Queries::User
      USERS = {
        1 => 'Piet Snot',
        2 => 'Henk Hengelaar'
      }

      def self.by_id(attributes = {})
        USERS[attributes.fetch(:id)]
      end
    end
  end

  include Pavlov::Helpers

  it 'can call method-based queries' do
    expect(query :'user/by_id', id: 1).to eq('Piet Snot')
  end
end
