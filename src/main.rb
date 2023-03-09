require_relative './app'

class Menu
  def initialize
    @options = []
  end

  def add_option(name, callback)
    @options << [name, callback]
  end

  def show
    loop do
      puts 'Please choose an option:'
      @options.each_with_index do |option, index|
        puts "#{index + 1}. #{option[0]}"
      end
      puts '0. Quit'

      choice = gets.chomp.to_i
      if choice.zero?
        puts 'Thank you using me'
        break
      elsif choice.positive? && choice <= @options.size
        @options[choice - 1][1].call
      else
        puts 'Invalid choice, please try again.'
      end
    end
  end
end

menu = Menu.new
app = App.new
menu.add_option('List all books', -> { app.list_books })
menu.add_option('List all people', -> { app.list_people })
menu.add_option('Create a person', -> { app.create_person })
menu.add_option('Create a book', -> { app.create_book })
menu.add_option('Create a rental', -> { app.create_rental })
menu.add_option('List all rentals for a given person id', -> { app.list_rentals })

menu.show
