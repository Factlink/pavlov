require 'rspec'
require 'coveralls'

Coveralls.wear!

$LOAD_PATH << './lib/'

RSpec.configure do |config|

  config.after :each do
    if defined?(Commands)
      Commands.constants.each do |const_name|
        Commands.send(:remove_const, const_name)
      end
    end

    if defined?(Queries)
      Queries.constants.each do |const_name|
        Queries.send(:remove_const, const_name)
      end
    end

    if defined?(Interactors)
      Interactors.constants.each do |const_name|
        Interactors.send(:remove_const, const_name)
      end
    end
  end
end
