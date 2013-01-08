module Pavlov
  module Helpers
    def interactor name, *args
      args = add_pavlov_options args
      Pavlov.interactor name, *args
    end

    def query name, *args
      args = add_pavlov_options args
      Pavlov.query name, *args, pavlov_options
    end

    def command name, *args
      args = add_pavlov_options args
      Pavlov.command name, *args, pavlov_options
    end

    def pavlov_options
      {}
    end

    private
    def add_pavlov_options args
      # TODO: we should do this at a point where we know how many arguments we need
      # so we can decide if we need to merge with another options object or
      # just add it.
      if pavlov_options != {}
        args << pavlov_options
      end
      args
    end
  end
end
