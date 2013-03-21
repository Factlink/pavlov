require 'rails/generators'

module Pavlov
  class QueryGenerator < Rails::Generators::NamedBase
    def create_query_file
      template 'query.rb', File.join('app/use_cases/queries', "#{singular_table_name}.rb")
    end

    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
    end
  end
end