require 'backports/rails/string'

module Pavlov
  class Inflector
    def self.camelize(string, first_letter = :upper)
      # Feel free to reimplement if you want to get rid of backports dependency.
      string.camelize
    end

    def self.constantize(string)
      # Feel free to reimplement if you want to get rid of backports dependency.
      string.constantize
    end
  end
end