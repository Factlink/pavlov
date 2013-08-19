require_relative '../spec_helper'
require 'pavlov'

describe 'Pavlov attributes' do
  before do
    stub_const 'Interactors', Module.new
    module Interactors
      class CreateBlogPost
        include Pavlov::Interactor

        attribute :title,     String
        attribute :published, Boolean, default: true

        private

        def authorized?
          true
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

  it 'saves attributes given during initialization' do
    interaction = Interactors::CreateBlogPost.new title: 'Why you should use Pavlov'
    expect(interaction.call).to eq 'WHY YOU SHOULD USE PAVLOV'
  end

  it 'overrides default attributes' do
    interaction = Interactors::CreateBlogPost.new title: 'Why you should use Pavlov',
                                                  published: false
    expect(interaction.call).to eq 'Why you should use Pavlov'
  end

end
