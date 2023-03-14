require_relative './person'
require_relative './student'
require_relative './teacher'
require_relative './books'
require_relative './classroom'
require_relative './rental'
require 'json'

class App
  attr_reader :people, :books, :rentals

  def initialize
    @people = []
    @books = []
    @rentals = []
    load_data
  end

  def list_people
    puts 'Listing all people:'
    @people.each do |person|
      puts "ID: #{person.id}, Name: #{person.correct_name}, Type: #{person.class}"
    end
  end

  def create_person
    puts 'Is the person a student or a teacher?'
    person_type = gets.chomp.downcase

    puts 'What is the person\'s name?'
    name = gets.chomp

    puts 'What is the person\'s age?'
    age = gets.chomp.to_i

    if person_type == 'student'
      puts 'Does the student have parent permission? (y/n)'
      parent_permission = gets.chomp.downcase == 'y'
      create_student(age, name, parent_permission, classroom_label: nil)
    elsif person_type == 'teacher'
      puts 'What is the teacher\'s specialization?'
      specialization = gets.chomp
      create_teacher(age, name, specialization, parent_permission: true)
    else
      puts 'Invalid option, please try again'
    end
  end

  def create_student(age, name, parent_permission, classroom_label: nil)
    classroom = nil
    classroom = Classroom.new(classroom_label) if classroom_label
    student = Student.new(age, name, parent_permission: parent_permission, classroom: classroom)
    @people << student
    puts "Created new student with ID #{student.id} and name #{student.correct_name}"
  end

  def create_teacher(age, name, specialization, parent_permission: true)
    puts name
    teacher = Teacher.new(age, specialization, name, parent_permission: parent_permission)
    @people << teacher
    puts "Created new teacher with ID #{teacher.id} and name #{teacher.correct_name}"
  end

  def create_book
    puts 'What is the title of the book?'
    title = gets.chomp

    puts 'Who is the author of the book?'
    author = gets.chomp

    book = Book.new(title, author)
    @books << book
    puts "Created new book with ID #{book.id}, title '#{book.title}', and author '#{book.author}'"
  end

  def list_books
    if @books.empty?
      puts 'No books available'
    else
      @books.each do |book|
        puts "ID: #{book.id}, Title: #{book.title}, Author: #{book.author}"
      end
    end
  end

  def create_rental
    puts 'What is the person id?'
    person_id = gets.chomp.to_i

    puts 'What is the book id?'
    book_id = gets.chomp.to_i

    puts 'What is the rental date? (YYYY-MM-DD)'
    date = gets.chomp

    person = @people.find { |p| p.id == person_id }
    book = @books.find { |b| b.id == book_id }
    if person && book
      rental = Rental.new(date, person, book)
      @rentals << rental
      puts "Created new rental with ID #{rental.object_id}"
    else
      puts 'Invalid person ID or book ID'
    end
  end

  def list_rentals
    puts 'What is the person id?'
    person_id = gets.chomp.to_i
    person = @people.find { |p| p.id == person_id }
    if person
      puts "Listing rentals for #{person.correct_name}:"
      person.rentals.each do |rental|
        puts "ID: #{rental.object_id}, Book Title: #{rental.book.title}, Date: #{rental.date}"
      end
    else
      puts 'Invalid person ID'
    end
  end

  def save_data
    save_people
    save_books
    save_rentals
    puts 'Thanks For Using me'
  end

  def load_data
    load_people
    load_books
    load_rentals
  end

  private

  def save_people
    File.write('people.json', JSON.pretty_generate(@people))
  end

  def save_books
    File.write('books.json', JSON.pretty_generate(@books))
  end

  def save_rentals
    File.write('rentals.json', JSON.pretty_generate(@rentals))
  end

  def load_people
    return unless File.exist?('people.json')

    @people = JSON.parse(File.read('people.json')).map do |person_data|
      if person_data['Type'] == 'Student'
        create_student(person_data['age'], person_data['name'], person_data['parent_permission'],
                       classroom_label: person_data['classroom_label'])
      else
        create_teacher(person_data['age'], person_data['name'], person_data['specialization'],
                       parent_permission: person_data['parent_permission'])
      end
    end
  end

  def load_books
    return unless File.exist?('books.json')

    @books = JSON.parse(File.read('books.json')).map do |book_data|
      Book.new(book_data['title'], book_data['author'])
    end
  end

  def load_rentals
    return unless File.exist?('rentals.json')

    @rentals = JSON.parse(File.read('rentals.json')).map do |rental_data|
      person = @people.find { |p| p.name == rental_data['name'] }
      book = @books.find { |b| b.title == rental_data['title'] }
      if person
        Rental.new(rental_data['date'], person, book)
      else
        puts "Could not find person with name #{rental_data['name']} for rental of book #{rental_data['title']}"
      end
    end
  end
end
