require_relative '../spec_helper'
require 'pavlov'

describe 'Pavlov interactors' do
  before do
    stub_const 'SecureRandom', double(uuid: '1234')
    stub_const 'REDIS', double(hmset: nil, sadd: nil)

    stub_const 'Backend', Class.new(Pavlov::Backend)

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
        [pavlov_options[:uuid_prefix], SecureRandom.uuid].join('_')
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
        Struct.new(:id, :title, :body).new(available_id, title, body)
      end

      def available_id
        query :available_id
      end
    end
  end

  let(:current_user) { double(is_admin?: true) }

  include Pavlov::Helpers

  def pavlov_options
    { uuid_prefix: 'helper_based_prefix' }
  end

  it 'can call commands and queries with helpers' do
    blog_post = interactor :create_blog_post, title: 'Why you should use Pavlov', body: 'Because it is really cool.'
    expect(blog_post.id).to eq('helper_based_prefix_1234')
    expect(blog_post.title).to eq('Why you should use Pavlov')
    expect(blog_post.body).to eq('Because it is really cool.')
  end

  it 'can call commands and queries with backend' do
    backend = Backend.new(pavlov_options: { uuid_prefix: 'backend_based_prefix' })
    blog_post = backend.interactor :create_blog_post, title: 'Why you should use Pavlov', body: 'Because it is really cool.'
    expect(blog_post.id).to eq('backend_based_prefix_1234')
    expect(blog_post.title).to eq('Why you should use Pavlov')
    expect(blog_post.body).to eq('Because it is really cool.')
  end
end
