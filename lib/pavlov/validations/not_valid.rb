module Pavlov
  module Validations
    class NotValid < StandardError 
      attr_accessor :errors
    end
  end
end