require 'rails/generators'

module Pavlov
  class InstallGenerator < Rails::Generators::Base
    def self.source_root
      @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
    end

    def copy_backend_directory
      directory 'backend', 'app/backend', recursive: true
    end

    def add_backend_to_autoload_paths
      application "config.autoload_paths += %W(\#{config.root}/app/backend)"
    end
  end
end