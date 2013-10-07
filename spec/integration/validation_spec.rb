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

  it 'fails for invalid attributes' do
    interaction = Interactors::CreateBlogPost.new title: 'Why you should eat ice cream'
    expect(interaction.valid?).to be_false
    expect(interaction.errors[:title]).to eq ['must mention Pavlov']
    expect { interaction.call }.to raise_error(Pavlov::ValidationError)
  end

  it 'With block and interaction#valid? is false' do
    render = nil
    Pavlov.interactor :create_blog_post, title: 'Why you should eat ice cream' do |interaction|
      if interaction.valid?
        render = interaction.call
      else
        render = :error
      end
    end

    expect(render).to eq :error
  end

  it 'With block and interaction#valid? is true' do
    render = nil
    Pavlov.interactor :create_blog_post, title: 'Why you should use Pavlov' do |interaction|
      if interaction.valid?
        render = interaction.call
      else
        render = :error
      end
    end

    expect(render).to eq 'WHY YOU SHOULD USE PAVLOV'
  end
end
