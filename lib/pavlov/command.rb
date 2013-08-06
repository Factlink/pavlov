require_relative 'concern'
require_relative 'operation'

module Pavlov
  module Command
    extend Pavlov::Concern
    include Pavlov::Operation
  end
end
