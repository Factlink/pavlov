module Pavlov
  module Helpers
    module RSpecHelpers
      def stub_query(query_name, options = {})
        Pavlov.stub(:query).with(query_name, options)
      end
    end
  end
end

RSpec.configure do |config|
  config.include Pavlov::Helpers::RSpecHelpers
end