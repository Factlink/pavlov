require 'rails/generators'

module Pavlov
  class CommandGenerator < Rails::Generators::NamedBase
    def create_command_file
      template 'command.rb', File.join('app/use_cases/commands', "#{singular_table_name}.rb")
    end

    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
    end
  end
end