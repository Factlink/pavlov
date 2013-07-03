require 'active_support/concern'
require_relative 'operation'

module Pavlov
  module Query
    extend ActiveSupport::Concern
    include Pavlov::Operation
  end
end
