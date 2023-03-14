require_relative './person'
require_relative './classroom'
class Student < Person
  attr_accessor :classroom

  def initialize(age, name, parent_permission: true, classroom: nil)
    super(age, name, parent_permission: parent_permission)
    @classroom = classroom
    if classroom.nil?
      # Do nothing
    else
      classroom.add_student(self)
    end
  end

  def play_hooky
    '¯\\(ツ)/¯'
  end
end
