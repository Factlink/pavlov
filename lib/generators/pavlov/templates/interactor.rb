module Interactors
  class <%= class_name %>
    include Pavlov::Interactor

    private

    def execute
    end

    def authorized?
      raise NotImplementedError
    end
  end
end