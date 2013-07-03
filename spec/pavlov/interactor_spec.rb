require 'pavlov'

describe Pavlov::Interactor do
  it 'should have a class which has a queue method which returns a default queue' do
    i = Class.new

    i.send(:include, Pavlov::Interactor)

    i.queue.should == :interactor_operations
  end

  it "raises an error when .authorized? does not exist" do
    dummy_class = Class.new do
      include Pavlov::Interactor
    end
    expect(-> {dummy_class.new}).to raise_error(NotImplementedError)
  end
end
