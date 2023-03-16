require_relative './nameable'

class Person < Nameable
  attr_accessor :id, :rentals, :name, :age, :parent_permission

  @id_counter = 0
  def initialize(age, name, parent_permission: true)
    super()
    @id = next_id
    @age = age
    @name = name
    @parent_permission = parent_permission
    @rentals = []
  end

  def rent(book, date)
    Rental.new(date, self, book)
  end

  def can_use_services?
    of_age? || @parent_permission
  end

  def correct_name
    @name
  end

  private

  def of_age?
    @age >= 18
  end

  def next_id
    @id_counter = self.class.instance_variable_get(:@id_counter) || 0
    self.class.instance_variable_set(:@id_counter, @id_counter + 1)
  end
end
