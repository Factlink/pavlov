module Pavlov
  module Helpers
    def interactor name, hash = {}
      if backend
        backend.interactor name, with_pavlov_options(hash)
      else
        Pavlov.interactor name, with_pavlov_options(hash)
      end
    end

    def query name, hash = {}
      if backend
        backend.query name, with_pavlov_options(hash)
      else
        Pavlov.query name, with_pavlov_options(hash)
      end
    end

    def command name, hash = {}
      if backend
        backend.command name, with_pavlov_options(hash)
      else
        Pavlov.command name, with_pavlov_options(hash)
      end
    end

    def backend
      nil
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
