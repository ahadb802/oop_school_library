require_relative './nameable'

class Person < Nameable
  attr_accessor :id, :rentals, :name, :age, :type

  @id_counter = 0

  def initialize(age, name, type, parent_permission: true)
    super()
    @id = next_id
    @age = age
    @name = name
    @parent_permission = parent_permission
    @type = type
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

  def to_h
    {
      id: @id,
      name: @name,
      age: @age,
      parent_permission: @parent_permission,
      rentals: @rentals.map(&:to_h),
      type: @type
    }
  end

  private

  @id_counter = 0

  def of_age?
    @age >= 18
  end

  def next_id
    @id_counter ||= load_id_counter
    @id_counter += 1
    save_id_counter
    @id_counter
  end

  def load_id_counter
    if File.exist?('id_counter.json')
      JSON.parse(File.read('id_counter.json'))['counter']
    else
      0
    end
  end

  def save_id_counter
    File.write('id_counter.json', { counter: @id_counter }.to_json)
  end
end
