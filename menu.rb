require_relative './app'
class Menu
  def initialize
    @options = []
  end

  def add_option(name, callback)
    @options << [name, callback]
  end

  def show
    # app = App.new
    # app.load_data
    loop do
      puts 'Please choose an option:'
      @options.each_with_index do |option, index|
        puts "#{index + 1}. #{option[0]}"
      end
      choice = gets.chomp.to_i
      if choice.zero?
        puts 'Thanks For Using me'
        break
      elsif choice.positive? && choice <= @options.size
        @options[choice - 1][1].call
      else
        puts 'Invalid choice, please try again.'
      end
    end
  end
end
