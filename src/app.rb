require_relative './books'
require_relative './person'
require_relative './rental'
require_relative './student'
require_relative './teacher'
class App
  def initialize
    @books = []
    @people = []
    @rentals = []
  end

  def list_books
    puts 'List of books:'
    @books.each do |book|
      puts "#{book.title} by #{book.author}"
    end
  end

  def list_people
    puts 'List of people:'
    @people.each do |person|
      puts "#{person.id}: #{person.name} (#{person.class})"
    end
  end

  def create_person(name, age, type)
    @people << if type == 'teacher'
                 Teacher.new(name, age)
               else
                 Student.new(name, age)
               end
  end

  def create_book(title, author)
    @books << Book.new(title, author)
  end

  def create_rental(book_id, person_id, date)
    book = @books.find { |b| b.id == book_id }
    person = @people.find { |p| p.id == person_id }
    @rentals << Rental.new(date, book, person)
  end

  def list_rentals(person_id)
    person_rentals = @rentals.select { |r| r.person.id == person_id }
    puts "Rentals for person with ID #{person_id}:"
    person_rentals.each do |rental|
      puts "#{rental.book.title} (rented on #{rental.date})"
    end
  end
end

# Example usage
app = App.new
app.create_book('The Hitchhiker\'s Guide to the Galaxy', 'Douglas Adams')
app.create_book('Harry Potter and the Philosopher\'s Stone', 'J.K. Rowling')
app.create_person('John Doe', 25, 'student')
app.create_person('Jane Smith', 35, 'teacher')
app.create_rental(1, 1, '2023-03-08')
app.create_rental(2, 1, '2023-02-14')
app.list_books
app.list_people
app.list_rentals(1)
