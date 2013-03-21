module Interactors
  class <%= class_name %>
    include Pavlov::Interactor

    def execute
    end

    private

    def authorized?
      raise NotImplementedError
    end
  end
end