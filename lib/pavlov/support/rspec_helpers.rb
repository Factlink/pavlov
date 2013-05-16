module Pavlov
  module Support
    module RSpecHelpers
      def stub_query(query_name, options = {})
        Pavlov.stub(:query).with(query_name, options)
      end
    end
  end
end

RSpec.configure do |config|
  config.include Pavlov::Support::RSpecHelpers
end