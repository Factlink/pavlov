require_relative 'pavlov_helper'

describe 'Interactors::ExampleModule::Followers' do
  include PavlovSupport

  let(:described_class) { Interactors::ExampleModule::Followers }

  before do
    stub_const 'Interactors', Module.new
    stub_const 'Interactors::ExampleModule', Module.new

    class Interactors::ExampleModule::Followers
      include Pavlov::Interactor

      arguments :user_name, :skip, :take

      def authorized?
        !!pavlov_options[:current_user]
      end

      def validate
        validate_nonempty_string :user_name, user_name
        validate_integer :skip, skip
        validate_integer :take, take
      end

      def execute
        user = query(:'user_by_username', username: user_name)

        graph_user_ids = query(:'example_module/follower_graph_user_ids', graph_user_id: user.graph_user_id.to_s)
        users = query(:'users_by_graph_user_ids', graph_user_ids: graph_user_ids)

        followed_by_me = graph_user_ids.include? pavlov_options[:current_user].graph_user_id

        count = users.length
        users = users.drop(skip).take(take)

        [users, count, followed_by_me]
      end
    end
  end

  describe '#authorized?' do
    before do
      described_class.any_instance.stub(validate: true)
    end

    it 'throws when no current_user' do
      expect do
        described_class.new(user_name: double, skip: double, take: double).call
      end.to raise_error(Pavlov::AccessDenied, 'Unauthorized')
    end
  end

  describe '#validate' do
    it 'without user_id doesn\'t validate' do
      expect_validating(user_name: 12, skip: 2, take: 12)
        .to fail_validation('user_name should be a nonempty string.')
    end

    it 'without user_id doesn\'t validate' do
      expect_validating(user_name: 'karel', skip: 'a', take: 12)
        .to fail_validation('skip should be an integer.')
    end

    it 'without user_id doesn\'t validate' do
      expect_validating(user_name: 'karel', skip: 2, take: 'b')
        .to fail_validation('take should be an integer.')
    end
  end

  describe '#call' do
    before do
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'with a more complex #execute' do
      user_name = double
      skip = double
      take = double
      current_user = double(graph_user_id: double)
      pavlov_options = { current_user: current_user }
      interactor = described_class.new(user_name: user_name, skip: skip, take: take, pavlov_options: pavlov_options)
      users = double(length: double)
      graph_user_ids = double
      user = double(graph_user_id: double)
      followed_by_me = true

      Pavlov.should_receive(:query)
            .with(:'user_by_username', username: user_name, pavlov_options: pavlov_options)
            .and_return(user)
      Pavlov.should_receive(:query)
            .with(:'example_module/follower_graph_user_ids', graph_user_id: user.graph_user_id.to_s, pavlov_options: pavlov_options)
            .and_return(graph_user_ids)
      Pavlov.should_receive(:query)
            .with(:'users_by_graph_user_ids', graph_user_ids: graph_user_ids, pavlov_options: pavlov_options)
            .and_return(users)

      graph_user_ids.should_receive(:include?)
        .with(current_user.graph_user_id)
        .and_return(followed_by_me)

      users.should_receive(:drop)
        .with(skip)
        .and_return(users)
      users.should_receive(:take)
        .with(take)
        .and_return(users)

      returned_users, returned_count, returned_followed_by_me = interactor.call

      expect(returned_users).to eq users
      expect(returned_count).to eq users.length
      expect(returned_followed_by_me).to eq followed_by_me
    end
  end
end
