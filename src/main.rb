require_relative './app'
require_relative './menu'

menu = Menu.new
app = App.new
menu.add_option('List all books', -> { app.list_books })
menu.add_option('List all people', -> { app.list_people })
menu.add_option('Create a person', -> { app.create_person })
menu.add_option('Create a book', -> { app.create_book })
menu.add_option('Create a rental', -> { app.create_rental })
menu.add_option('List all rentals for a given person id', -> { app.list_rentals })
menu.add_option('Quit', -> { app.quit })
menu.show
