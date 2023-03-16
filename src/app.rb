require_relative './person'
require_relative './student'
require_relative './teacher'
require_relative './books'
require_relative './classroom'
require_relative './rental'
require 'json'
# rubocop:disable Metrics/ClassLength
class App
  attr_reader :people, :books, :rentals

  def initialize
    @people = []
    @books = []
    @rentals = []
    load_data
    @data_changed = false
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
      create_student(age, name, person_type, parent_permission, classroom_label: nil)
    elsif person_type == 'teacher'
      puts 'What is the teacher\'s specialization?'
      specialization = gets.chomp
      create_teacher(age, specialization, name, person_type, parent_permission: true)
    else
      puts 'Invalid option, please try again'
    end
  end

  def create_student(age, name, person_type, parent_permission, classroom_label: nil)
    classroom = nil
    classroom = Classroom.new(classroom_label) if classroom_label
    student = Student.new(age, name, person_type, parent_permission: parent_permission, classroom: classroom)
    @people << student
    puts "Created new student with ID #{student.id} and name #{student.correct_name}"
  end

  def create_teacher(age, specialization, name, person_type, parent_permission: true)
    teacher = Teacher.new(age, specialization, name, person_type, parent_permission: parent_permission)
    @people << teacher
    puts "Created new teacher with ID #{teacher.id} and name #{teacher.correct_name}"
  end

  def create_book
    @data_changed = true
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
    exit
  end

  def load_data
    load_books
    load_people
    load_rentals
  end

  private

  def load_books
    return unless File.file?('books.json')

    books_data = JSON.parse(File.read('books.json'))
    books_data.each do |book_data|
      book = Book.new(book_data['title'], book_data['author'])
      @books << book
    end
  end

  def save_books
    return unless @data_changed

    # only save new data if it has changed since the last save
    books_data = @books.map(&:to_h)
    # write the updated data to the file, overwriting the existing file
    File.write('books.json', JSON.pretty_generate(books_data), mode: 'w')
    # reset the data_changed flag
    @data_changed = false
  end

  def save_people
    # create a new hash for the data
    people_data = { people: @people.map(&:to_h) }

    # write the updated data to the file
    File.write('people.json', JSON.pretty_generate(people_data))
  end

  def load_people
    return unless File.file?('people.json')

    # read the existing data from the file
    people_data = JSON.parse(File.read('people.json'))

    # create new person objects from the data
    people_data['people'].each do |person_data|
      if person_data['type'] == 'student'
        student = Student.new(person_data['age'], person_data['name'], person_data['type'],
                              parent_permission: person_data['parent_permission'], classroom: nil)
        student.instance_variable_set(:@id, person_data['id'])
        @people << student
      elsif person_data['type'] == 'teacher'
        teacher = Teacher.new(person_data['age'], person_data['name'], person_data['specialization'], person_data['type'], parent_permission: person_data['parent_permission']) # rubocop:disable Layout/LineLength

        teacher.instance_variable_set(:@id, person_data['id'])
        @people << teacher
      end
    end
  end

  def save_rentals
    rentals_data = []
    if File.file?('rentals.json')
      # read the existing data from the file
      rentals_data = JSON.parse(File.read('rentals.json'))
    end
    # add the new data to the existing data
    rentals_data.concat(@rentals.reject { |rental| rentals_data.include?(rental.to_h) }.map(&:to_h))
    # write the updated data to the file
    File.write('rentals.json', JSON.pretty_generate(rentals_data))
  end

  def load_rentals
    rentals_data = []
    rentals_data = JSON.parse(File.read('rentals.json')) if File.file?('rentals.json')
    rentals_data.each do |rental_data|
      person = @people.find { |p| p.id == rental_data['person_id'] }
      book = @books.find { |b| b.id == rental_data['book_id'] }
      next unless person && book

      rental = Rental.new(rental_data['date'], person, book)
      rental.instance_variable_set(:@id, rental_data['id'])
      @rentals << rental
      person.rentals << rental
    end
  end
  # rubocop:enable Metrics/ClassLength
end
