require_relative '../books'
require 'json'
require 'fileutils'

describe Book do
  let(:book) { Book.new('Title', 'Author') }

  describe '#initialize' do
    it 'sets the book title and author' do
      expect(book.title).to eq('Title')
      expect(book.author).to eq('Author')
    end

    it 'assigns a unique ID to the book' do
      expect(book.id).to_not be_nil
      expect(book.id).to be_a(Integer)
    end

    it 'initializes rentals as an empty array' do
      expect(book.rentals).to be_empty
    end
  end

  describe '#add_rental' do
    it "adds a rental to the book's rental list" do
      rental = double('rental')
      book.add_rental(rental)
      expect(book.rentals).to include(rental)
    end
  end

  describe '#to_h' do
    it 'returns a hash representation of the book' do
      rental = double('rental', to_h: { foo: 'bar' })
      book.add_rental(rental)
      expected_hash = {
        id: book.id,
        title: book.title,
        author: book.author,
        rentals: [{ foo: 'bar' }]
      }
      expect(book.to_h).to eq(expected_hash)
    end
  end

  describe 'private methods' do
    describe '#next_id' do
      it 'returns the next available ID' do
        expect(book.send(:next_id)).to eq(book.id + 1)
      end

      it 'saves the ID counter to a file' do
        expect(File).to receive(:write).with('id_counter.json', { counter: book.id + 1 }.to_json)
        book.send(:next_id)
      end
    end

    describe '#load_id_counter' do
      it 'loads the ID counter from a file if it exists' do
        File.write('id_counter.json', { counter: 123 }.to_json)
        expect(book.send(:load_id_counter)).to eq(124)
      end

      it 'returns 0 if the ID counter file does not exist' do
        allow(File).to receive(:exist?).with('id_counter.json').and_return(false)
        expect(book.send(:load_id_counter)).to eq(0)
      end
    end

    describe '#save_id_counter' do
      before do
        FileUtils.rm_f('id_counter.json')
      end

      it 'saves the ID counter to a file' do
        book.send(:next_id)
        expect(File).to receive(:write).with('id_counter.json',
                                             { counter: book.instance_variable_get(:@id_counter) }.to_json)
        book.send(:save_id_counter)
      end
    end
  end
end
