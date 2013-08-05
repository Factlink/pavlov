class Interactor
  include Pavlov::Operation

  # If you want your interactors to be compatible with a backgrounding
  # daemon, you can use this base class to add support.
  #
  # Example for Resque:
  #
  # def self.perform(*args)
  #   new(*args).call
  # end

  def authorized?
    raise NotImplementedError
  end
end
