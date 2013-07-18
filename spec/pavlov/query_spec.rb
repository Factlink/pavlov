require_relative '../spec_helper'
require 'pavlov/query'

describe Pavlov::Query do
  let 'query_with_private_authorized?' do
    Class.new do
      include Pavlov::Query

      private
      def authorized?
        false
      end
    end
  end

  it "raises an error when private .authorized? does not exist" do
    query = query_with_private_authorized?.new

    expect do
      query.call
    end.to raise_error(Pavlov::AccessDenied)
  end
end
