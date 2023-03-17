require_relative '../person'
require_relative '../classroom'
require_relative '../student'
require 'json'

RSpec.describe Classroom do
  let(:classroom) { Classroom.new('Math') }
  let(:student) { Student.new(15, 'John Doe', 'Student') }

  describe '#initialize' do
    it 'sets the label' do
      expect(classroom.label).to eq('Math')
    end

    it 'creates an empty array of students' do
      expect(classroom.students).to eq([])
    end
  end

  describe '#add_student' do
    it 'adds a student to the list of students' do
      classroom.add_student(student)
      expect(classroom.students).to include(student)
    end

    it 'sets the student classroom attribute to the current classroom' do
      classroom.add_student(student)
      expect(student.classroom).to eq(classroom)
    end
  end
end
