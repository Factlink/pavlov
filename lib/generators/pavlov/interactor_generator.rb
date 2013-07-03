require 'rails/generators'

module Pavlov
  class InteractorGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def create_interactor_file
      template 'interactor.rb', File.join('app/use_cases/interactors', "#{singular_table_name}.rb")
    end
  end
end