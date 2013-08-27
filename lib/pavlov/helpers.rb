module Pavlov
  module Helpers
    def interactor name, hash = {}
      Pavlov.interactor name, with_pavlov_options(hash)
    end

    def query name, hash = {}
      Pavlov.query name, with_pavlov_options(hash)
    end

    def command name, hash = {}
      Pavlov.command name, with_pavlov_options(hash)
    end

    def pavlov_options
      {}
    end

    private

    def with_pavlov_options hash
      if pavlov_options != {}
        if hash.key? 'pavlov_options'
          hash[:pavlov_options] = pavlov_options.merge(hash[:pavlov_options])
        else
          hash[:pavlov_options] = pavlov_options
        end
      end
      hash
    end
  end
end
