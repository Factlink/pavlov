require_relative '../spec_helper'
require 'pavlov'

describe 'Pavlov backend' do
  before do
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
        @available_id ||= query :available_id
      end
    end

    stub_const 'Backend', Class.new(Pavlov::Backend)
  end

  let(:current_user)   { double(is_admin?: true) }
  let(:pavlov_options) { { current_user: current_user } }
  let(:backend)        { Backend.new(pavlov_options: pavlov_options) }

  let(:id)    { '123' }
  let(:title) { 'Why you should use Pavlov' }
  let(:body)  { 'Some arguments go here' }

  it 'can test interactors based on return values' do
    backend.stub(:command).with(:create_blog_post, anything)
    backend.stub(:query).with(:available_id, anything).and_return(id)

    blog_post = backend.interactor :create_blog_post, title: title, body: body

    expect(blog_post.id).to eq(id)
    expect(blog_post.title).to eq(title)
    expect(blog_post.body).to eq(body)
  end

  it 'can test interactors in with mock expectations' do
    backend.should_receive(:command)
           .with(:create_blog_post, id: id, title: title, body: body, published: true, pavlov_options: pavlov_options)
    backend.should_receive(:query)
           .with(:available_id, pavlov_options: pavlov_options).and_return(id)

    backend.interactor :create_blog_post, title: title, body: body
  end
end
