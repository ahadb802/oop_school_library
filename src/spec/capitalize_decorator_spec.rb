require_relative '../decorator'
require_relative '../capitalize_decorator'

RSpec.describe CapitalizeDecorator do
  let(:nameable) { double(:nameable, correct_name: 'john doe') }
  let(:decorator) { CapitalizeDecorator.new(nameable) }

  describe '#correct_name' do
    it 'capitalizes the name returned by the decorated object' do
      expect(decorator.correct_name).to eq('John doe')
    end
  end
end