require 'rails/generators'

module Pavlov
  class QueryGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def create_query_file
      template 'query.rb', File.join('app/use_cases/queries', "#{singular_table_name}.rb")
    end

    # This would invoke whatever test framework is defined,
    # but none seem to have any way of generating for just
    # any old object instead of "model" or "helper" etc...
    #
    # hook_for :test_framework
  end
end