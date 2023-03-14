require 'json'

class Book
  attr_reader :id, :title, :author, :rentals

  @id_counter = 0

  def initialize(title, author)
    @id = next_id
    @title = title
    @author = author
    @rentals = []
  end

  def add_rental(rental)
    @rentals << rental
  end

  private

  def next_id
    @id_counter = self.class.instance_variable_get(:@id_counter) || 0
    self.class.instance_variable_set(:@id_counter, @id_counter + 1)
  end
end
