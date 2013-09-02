module Pavlov
  module Helpers
    def interactor name, hash = {}
      backend.interactor name, with_pavlov_options(hash)
    end

    def query name, hash = {}
      backend.query name, with_pavlov_options(hash)
    end

    def command name, hash = {}
      backend.command name, with_pavlov_options(hash)
    end

    def backend
      Pavlov
    end

    def pavlov_options
      {}
    end

    private

    def with_pavlov_options hash
      hash[:pavlov_options] = pavlov_options.merge(hash.fetch(:pavlov_options, {}))
      hash
    end
  end
end
