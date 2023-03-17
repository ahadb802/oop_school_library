require_relative '../teacher'
require 'json'

RSpec.describe Teacher do
  let(:teacher) { Teacher.new(35, 'Math', 'Ms. Johnson', 'teacher') }

  describe '#initialize' do
    it 'sets the age, name, type, and specialization' do
      expect(teacher.age).to eq(35)
      expect(teacher.name).to eq('Ms. Johnson')
      expect(teacher.type).to eq('teacher')
      expect(teacher.specialization).to eq('Math')
    end

    it 'sets the parent_permission to true by default' do
      expect(teacher.parent_permission).to eq(true)
    end
  end

  describe '#can_use_services?' do
    it 'returns true' do
      expect(teacher.can_use_services?).to eq(true)
    end
  end
end