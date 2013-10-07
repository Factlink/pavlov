require_relative 'pavlov_helper'

describe 'Commands::CreateActivity' do
  include PavlovSupport

  let(:current_user) { double('current_user', id: 2) }
  let(:user)         { double('user', id: 1, user_id: current_user.id) }
  let(:other_user)   { double('user', id: 1, user_id: current_user.id + 1)  }

  before do
    stub_const 'Commands', Module.new

    class Commands::CreateActivity
      include Pavlov::Command

      arguments :user, :action, :subject, :object

      def execute
        Activity.create(user: user, action: action, subject: subject, object: object)
      end
    end

    stub_classes 'Activity'
  end

  describe '#call' do
    it 'should call an external library' do
      action = :test
      activity_subject = double
      activity_object = double
      command = Commands::CreateActivity.new user: user, action: action,
                                             subject: activity_subject, object: activity_object
      Activity.should_receive(:create).with(user: user, action: action, subject: activity_subject, object: activity_object)

      command.call
    end
  end
end
