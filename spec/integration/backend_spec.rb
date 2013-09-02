require_relative '../spec_helper'
require 'pavlov'

describe 'Pavlov backend' do
  before do
    stub_const 'Interactors', Module.new
    module Interactors
      class CreateBlogPost
        include Pavlov::Interactor

        attribute :title,     String
        attribute :published, Boolean, default: true

        private

        def authorized?
          context[:current_user].is_admin?
        end

        def execute
          title.upcase!
        end
      end
    end

    stub_const 'Backend', Class.new(Pavlov::Backend)
  end

  let(:current_user) { double(is_admin?: true) }
  let(:backend)      { Backend.new(current_user: current_user) }

  it 'calls interactors' do
    interaction = backend.interactor :create_blog_post, title: 'Why you should use Pavlov'
    expect(interaction.call).to eq 'WHY YOU SHOULD USE PAVLOV'
  end
end
