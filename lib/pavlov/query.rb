require_relative 'concern'
require_relative 'operation'

module Pavlov
  module Query
    extend Pavlov::Concern
    include Pavlov::Operation
  end
end
