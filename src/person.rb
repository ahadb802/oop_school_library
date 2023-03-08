require_relative './nameable'

class Person < Nameable
  # ...

  attr_reader :id, :rentals

  def initialize(_age, _name = 'Unknown', *)
    super()
    # ...
    @id = rand(1000)
    @rentals = []
  end

  def rent(book, date)
    Rental.new(date, self, book)
  end

  # ...

  def can_use_services?
    is_of_age? || @parent_permission
  end

  def correct_name
    @name
  end

  private

  def of_age?
    @age >= 18
  end
end
