require 'rails/generators'

module Pavlov
  class CommandGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def create_command_file
      template 'command.rb', File.join('app/use_cases/commands', "#{singular_table_name}.rb")
    end
  end
end