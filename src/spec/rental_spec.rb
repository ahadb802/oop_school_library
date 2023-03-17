require_relative '../rental'
require_relative '../person'
require_relative '../books'
require 'json'

RSpec.describe Rental do
  let(:person) { Person.new('John Doe', 30, 'male') }
  let(:book) { Book.new('The Great Gatsby', 'F. Scott Fitzgerald') }
  let(:rental_date) { '2023-03-17' }
  let(:rental) { Rental.new(rental_date, person, book) }

  describe '#initialize' do
    it 'sets the date' do
      expect(rental.date).to eq(rental_date)
    end

    it 'sets the person' do
      expect(rental.person).to eq(person)
    end

    it 'sets the book' do
      expect(rental.book).to eq(book)
    end

    it 'adds the rental to the book' do
      expect(book.rentals).to include(rental)
    end

    it 'adds the rental to the person' do
      expect(person.rentals).to include(rental)
    end
  end

  describe '#to_h' do
    it 'returns a hash with the rental information' do
      expected_hash = {
        date: rental_date,
        person_id: person.id,
        book_id: book.id
      }
      expect(rental.to_h).to eq(expected_hash)
    end
  end
end
