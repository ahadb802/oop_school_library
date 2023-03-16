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

  def to_h
    {
      id: @id,
      title: @title,
      author: @author,
      rentals: @rentals.map(&:to_h)
    }
  end

  private

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
