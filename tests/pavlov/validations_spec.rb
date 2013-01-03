require 'minitest/autorun'

require_relative '../../lib/pavlov/validations'

describe Pavlov::Validations do
  describe '.errors' do
    let('test_class') do
      Class.new do
        include Pavlov::Validations::Errors
      end
    end

    # it 'must error when initialized to an invalid state' do
    #   test_class.create do
    #     self.drink_type = 'wine'
    #     self.alcohol_percentage = 20
    #   end
    # end
  end
end