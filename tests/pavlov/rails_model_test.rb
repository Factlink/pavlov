require 'minitest/autorun'

require_relative '../../lib/pavlov/model_rails'

class RailsModelTest < MiniTest::Unit::TestCase
  include ActiveModel::Lint::Tests
  class Test < Pavlov::Entity
    include Pavlov::RailsModel

    attributes :name, :test, :id
  end

  def setup
    @model = Test.new
  end 
end
