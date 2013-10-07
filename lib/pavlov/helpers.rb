module Pavlov
  module Helpers
    def interactor name, hash = {}, &block
      Pavlov.interactor name, with_pavlov_options(hash), &block
    end

    def query name, hash = {}, &block
      Pavlov.query name, with_pavlov_options(hash), &block
    end

    def command name, hash = {}, &block
      Pavlov.command name, with_pavlov_options(hash), &block
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
