require_relative '../person'
require_relative '../classroom'
require_relative '../student'
require 'json'

RSpec.describe Student do
  describe '#initialize' do
    let(:classroom) { Classroom.new('Math') }
    let(:student) { Student.new(16, 'John', 'Student', classroom: classroom) }

    it 'sets the classroom' do
      expect(student.classroom).to eq(classroom)
    end
  end

  describe '#play_hooky' do
    let(:student) { Student.new(16, 'John', 'Student') }

    it 'returns a string' do
      expect(student.play_hooky).to be_a(String)
    end

    it 'returns a specific string' do
      expect(student.play_hooky).to eq('¯\\(ツ)/¯')
    end
  end
end
