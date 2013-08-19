require_relative '../spec_helper'
require 'pavlov'

describe 'Pavlov interactors' do
  before do
    stub_const 'SecureRandom', double(uuid: '1234')
    stub_const 'REDIS', double(hmset: nil, sadd: nil)

    stub_const 'Commands', Module.new
    class Commands::CreateBlogPost
      include Pavlov::Command

      attribute :id,        String
      attribute :title,     String
      attribute :body,      String
      attribute :published, Boolean

      private

      def validate
      end

      def execute
        REDIS.hmset("blog_post:#{id}", title: title, body: body, published: published)
        REDIS.sadd('blog_post_list', id)
      end
    end

    stub_const 'Queries', Module.new
    class Queries::AvailableId
      include Pavlov::Query

      private

      def execute
        generate_uuid
      end

      def generate_uuid
        SecureRandom.uuid
      end
    end

    stub_const 'Interactors', Module.new
    class Interactors::CreateBlogPost
      include Pavlov::Interactor

      attribute :title,     String
      attribute :body,      String
      attribute :published, Boolean, default: true

      private

      def authorized?
        true
      end

      def validate
      end

      def execute
        command :create_blog_post, id: available_id,
                                   title: title,
                                   body: body,
                                   published: published
        Struct.new(:title, :body).new(title, body)
      end

      def available_id
        query :available_id
      end
    end
  end

  let(:current_user) { double(is_admin?: true) }

  include Pavlov::Helpers

  it 'can call commands and queries' do
    blog_post = interactor :create_blog_post, title: 'Why you should use Pavlov', body: 'Because it is really cool.'
    expect(blog_post.title).to eq('Why you should use Pavlov')
    expect(blog_post.body).to eq('Because it is really cool.')
  end
end
