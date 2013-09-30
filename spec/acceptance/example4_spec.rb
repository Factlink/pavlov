require_relative 'pavlov_helper'

module Interactors
  module ExampleModule
    class FollowUser
      include Pavlov::Interactor

      arguments :user_name, :user_to_follow_user_name

      def authorized?
        (!! pavlov_options[:current_user]) && (pavlov_options[:current_user].username == user_name)
      end

      def user
        @user ||= query(:'user_by_username', username: user_name)
      end

      def execute
        raise Pavlov::ValidationError, 'User does not exist any more.' unless user

        unless user.id.to_s == pavlov_options[:current_user].id.to_s
          throw 'Only supporting user == current_user when following user'
        end

        user_to_follow = query(:'user_by_username', username: user_to_follow_user_name)
        command(:'example_module/follow_user', user_id: user.id, user_to_follow_user_id: user_to_follow.id)
        command(:'create_activity', user: user, action: :followed_user, subject: user_to_follow, object: nil)

        # This command still depends on user == current_user
        command(:'example_module/add_activities_to_stream', user_id: user_to_follow.id)

        nil
      end

      def validate
        validate_nonempty_string :user_name, user_name
        validate_nonempty_string :user_to_follow_user_name, user_to_follow_user_name

        if user_name == user_to_follow_user_name
          raise Pavlov::ValidationError, 'You cannot follow yourself.'
        end
      end
    end
  end
end

describe Interactors::ExampleModule::FollowUser do
  include PavlovSupport

  describe '#authorized?' do
    before do
      described_class.any_instance
        .should_receive(:validate)
        .and_return(true)
    end

    it 'throws when no current_user' do
      expect do
        described_class.new(user_name: double, user_to_follow_user_name: double).call
      end.to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end

    it 'throws when updating someone else\'s follow' do
      username = double
      other_username = double
      current_user = double(username: username)
      options = { current_user: current_user }
      interactor = described_class.new(user_name: other_username, user_to_follow_user_name: double, pavlov_options: options)

      expect do
        interactor.call
      end.to raise_error Pavlov::AccessDenied, 'Unauthorized'
    end
  end

  describe '#call' do
    before do
      described_class.any_instance.stub(authorized?: true, validate: true)
    end

    it 'calls a command to follow user' do
      user = double(id: double, user_id: double, username: double)
      user_to_follow = double(id: double, user: double, username: double)
      options = { current_user: user }
      interactor = described_class.new(user_name: user.username, user_to_follow_user_name: user_to_follow.username, pavlov_options: options)

      Pavlov.should_receive(:query)
            .with(:'user_by_username', username: user.username, pavlov_options: options)
            .and_return(user)
      Pavlov.should_receive(:query)
            .with(:'user_by_username', username: user_to_follow.username, pavlov_options: options)
            .and_return(user_to_follow)
      Pavlov.should_receive(:command)
            .with(:'example_module/follow_user', user_id: user.id, user_to_follow_user_id: user_to_follow.id, pavlov_options: options)
      Pavlov.should_receive(:command)
            .with(:'create_activity', user: user, action: :followed_user, subject: user_to_follow, object: nil, pavlov_options: options)
      Pavlov.should_receive(:command)
            .with(:'example_module/add_activities_to_stream', user_id: user_to_follow.id, pavlov_options: options)

      expect(interactor.call).to eq nil
    end
  end

  describe 'validations' do
    it 'with a invalid user_name doesn\t validate' do
      expect_validating(user_name: 12, user_to_follow_user_name: 'karel')
        .to fail_validation('user_name should be a nonempty string.')
    end

    it 'with a invalid user_to_follow_user_name doesn\t validate' do
      expect_validating(user_name: 'karel', user_to_follow_user_name: 12)
        .to fail_validation('user_to_follow_user_name should be a nonempty string.')
    end

    it 'you don\'t try to follow yourself' do
      expect_validating(user_name: 'karel', user_to_follow_user_name: 'karel')
        .to fail_validation('You cannot follow yourself.')
    end
  end
end
