module Pavlov
  module Helpers
    def interactor name, hash
      hash = add_pavlov_options hash
      Pavlov.interactor name, hash
    end

    def query name, hash
      hash = add_pavlov_options hash
      Pavlov.query name, hash
    end

    def command name, hash
      hash = add_pavlov_options hash
      Pavlov.command name, hash
    end

    def pavlov_options
      {}
    end

    private
    def add_pavlov_options hash
      if pavlov_options != {}
        hash ||= {}
        hash[:pavlov_options] = pavlov_options.merge(hash[:pavlov_options])
      end
      hash
    end
  end
end
