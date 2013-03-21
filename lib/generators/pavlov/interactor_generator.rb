require 'rails/generators'

module Pavlov
  class InteractorGenerator < Rails::Generators::NamedBase
    def create_interactor_file
      template 'interactor.rb', File.join('app/use_cases/interactors', "#{singular_table_name}.rb")
    end

    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
    end
  end
end