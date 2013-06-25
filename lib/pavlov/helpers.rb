module Pavlov
  module Helpers
    def interactor name, options = {}
      options = add_pavlov_options(options)
      Pavlov.interactor name, options
    end

    def query name, options = {}
      options = add_pavlov_options(options)
      Pavlov.query name, options
    end

    def command name, options = {}
      options = add_pavlov_options(options)
      Pavlov.command name, options
    end

    def pavlov_options
      {}
    end

    private

    def add_pavlov_options options
      pavlov_options.merge(options)
    end
  end
end
