require 'json'
require 'date'
require_relative '../person'
require_relative '../books.rb'
require_relative '../rental'

RSpec.describe Person do
  let(:person) { Person.new(20, 'John Doe', 'student') }
  let(:book) { Book.new('The Catcher in the Rye', 'J.D. Salinger') }

  describe '#rent' do
    it 'creates a rental object' do
      rental = person.rent(book, Date.today)
      expect(rental).to be_a(Rental)
    end
  end

  describe '#can_use_services?' do
    context 'when person is of age' do
      let(:person) { Person.new(18, 'Jane Doe', 'student') }

      it 'returns true' do
        expect(person.can_use_services?).to eq(true)
      end
    end

    context 'when person is not of age and has parent permission' do
      let(:person) { Person.new(16, 'Jack Doe', 'student', parent_permission: true) }

      it 'returns true' do
        expect(person.can_use_services?).to eq(true)
      end
    end

    context 'when person is not of age and does not have parent permission' do
      let(:person) { Person.new(16, 'Jill Doe', 'student', parent_permission: false) }

      it 'returns false' do
        expect(person.can_use_services?).to eq(false)
      end
    end
  end

  describe '#correct_name' do
    it 'returns the person\'s name' do
      expect(person.correct_name).to eq('John Doe')
    end
  end

  describe '#to_h' do
    it 'returns a hash representation of the person object' do
      rental = person.rent(book, Date.today)
      person_hash = {
        id: person.id,
        name: 'John Doe',
        age: 20,
        parent_permission: true,
        rentals: [rental.to_h],
        type: 'student'
      }
      expect(person.to_h).to eq(person_hash)
    end
  end

  describe 'private methods' do
    describe '#of_age?' do
      context 'when person is of age' do
        let(:person) { Person.new(18, 'Jane Doe', 'student') }

        it 'returns true' do
          expect(person.send(:of_age?)).to eq(true)
        end
      end

      context 'when person is not of age' do
        let(:person) { Person.new(16, 'Jack Doe', 'student') }

        it 'returns false' do
          expect(person.send(:of_age?)).to eq(false)
        end
      end
    end

    describe '#next_id' do
      context 'when the id_counter file exists' do
        it "loads the ID counter from a file if it exists" do
          File.write('id_counter.json', { counter: 123 }.to_json)
          expect(book.send(:load_id_counter)).to eq(124)
        end
      end

      context 'when the id_counter file does not exist' do
        it "returns 0 if the ID counter file does not exist" do
          allow(File).to receive(:exist?).with('id_counter.json').and_return(false)
          expect(book.send(:load_id_counter)).to eq(0)
        end
      end
    end
  end
end