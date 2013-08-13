require_relative '../spec_helper'
require 'pavlov'

describe 'Pavlov validations' do
  before do
    stub_const 'Interactors', Module.new
    module Interactors
      class CreateBlogPost
        include Pavlov::Interactor

        attribute :title, String

        private

        def validate
          errors.add(:title, 'must mention Pavlov') unless title.downcase =~ /pavlov/
        end

        def authorized?
          true
        end

        def execute
          title.upcase!
        end
      end
    end
  end

  it 'accepts valid attributes' do
    interaction = Interactors::CreateBlogPost.new title: 'Why you should use Pavlov'
    expect(interaction.call).to eq 'WHY YOU SHOULD USE PAVLOV'
  end

  it 'overrides default attributes' do
    interaction = Interactors::CreateBlogPost.new title: 'Why you should eat ice cream'
    expect(interaction.valid?).to be_false
    expect(interaction.errors[:title]).to eq ['must mention Pavlov']
    expect { interaction.call }.to raise_error(Pavlov::ValidationError)
  end

end
