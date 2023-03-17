require_relative '../decorator'
require_relative '../trimmer_decorator'

describe TrimmerDecorator do
  let(:nameable) { double('Nameable', correct_name: 'Hello World') }
  let(:decorator) { TrimmerDecorator.new(nameable) }

  describe '#correct_name' do
    context 'when name length is greater than MAX_NAME_LENGTH' do
      it 'trims the name to MAX_NAME_LENGTH characters' do
        expect(decorator.correct_name).to eq('Hello Worl')
      end
    end

    context 'when name length is less than or equal to MAX_NAME_LENGTH' do
      let(:nameable) { double('Nameable', correct_name: 'Hello') }

      it 'returns the correct name' do
        expect(decorator.correct_name).to eq('Hello')
      end
    end
  end
end
