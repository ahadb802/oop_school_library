class Book
  # ...

  attr_reader :rentals

  def initialize(_title, _author)
    # ...
    @rentals = []
  end

  # ...
end
