require_relative 'pavlov_helper'

module Commands
  module ExampleModule
    class CleanList
      include Pavlov::Command
      arguments :list_key

      def execute
        members_to_remove.each do |member_id|
          list.zrem member_id
        end
      end

      private

      def list
        @list ||= Nest.new(list_key)
      end

      def members_to_remove
        list.zrange(0, -1).select do |id|
          activity = Activity[id]
          ! valid(activity)
        end
      end

      def valid activity
        activity && activity.still_valid?
      end
    end
  end
end

describe Commands::ExampleModule::CleanList do
  include PavlovSupport
  before do
    stub_classes 'Activity', 'Nest'
  end

  describe '#call' do
    it 'should delete nil activities' do
      key, keyname = double, double
      nil_activity = nil
      activities_by_id = {
        1 => nil_activity,
        2 => double(:activity, still_valid?: true)
      }

      Activity.stub(:[]) do |id|
        activities_by_id[id]
      end
      Nest.stub(:new).with(keyname).and_return(key)
      key.stub(:zrange).with(0, -1)
         .and_return(activities_by_id.keys)

      key.should_receive(:zrem)
         .with activities_by_id.key(nil_activity)

      command = described_class.new list_key: keyname
      command.call
    end

    it 'should delete activities which are invalid' do
      key, keyname = double, double
      unshowable_activity = double :activity, still_valid?: false
      activities_by_id = {
        0 => double(:activity, still_valid?: true),
        2 => unshowable_activity,
      }

      Activity.stub(:[]) do |id|
        activities_by_id[id]
      end
      Nest.stub(:new).with(keyname).and_return(key)
      key.stub(:zrange).with(0, -1)
         .and_return(activities_by_id.keys)

      key.should_receive(:zrem)
         .with activities_by_id.key(unshowable_activity)

      command = described_class.new list_key: keyname
      command.execute
    end
  end
end
