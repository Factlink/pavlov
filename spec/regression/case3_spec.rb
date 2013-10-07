require_relative 'pavlov_helper'

describe 'Interactors::ExampleModule::Count' do
  include PavlovSupport
  
  let(:described_class){ Interactors::ExampleModule::Count }

  before do
    stub_const 'Interactors', Module.new
    stub_const 'Interactors::ExampleModule', Module.new

    class Interactors::ExampleModule::Count
      include Pavlov::Interactor

      arguments :id, :timestamp

      def execute
        query :"example_module/count", id: id, timestamp: timestamp
      end

      def authorized?
        pavlov_options[:no_current_user] == true || pavlov_options[:current_user]
      end
    end
  end

  describe '#call' do
    it 'call\'s a query' do
      id = double
      timestamp = double
      count = double

      described_class.any_instance.should_receive(:authorized?).and_return true
      interactor = described_class.new id: id, timestamp: timestamp

      Pavlov.should_receive(:query)
            .with(:"example_module/count", id: id, timestamp: timestamp)
            .and_return count

      expect(interactor.call).to eq count
    end
  end

  describe '.authorized?' do
    it 'returns the passed current_user' do
      current_user = double
      interactor = described_class.new(id: double, timestamp: double, pavlov_options: { current_user: current_user })

      expect(interactor.authorized?).to eq current_user
    end

    it 'returns true when the :no_current_user option is true' do
      options = { no_current_user: true }
      interactor = described_class.new(id: double, timestamp: double,
                                                         pavlov_options: options)

      expect(interactor.authorized?).to eq true
    end

    it 'returns false when neither :current_user or :no_current_user are passed' do
      expect do
        interactor = described_class.new(channel_id: double, timestamp: double)
        interactor.call
      end.to raise_error(Pavlov::AccessDenied)
    end
  end
end
