require_relative './person'
require_relative './nameable'

class Student < Person
  include Nameable

  attr_accessor :classroom

  def initialize(age, name = 'Unknown', parent_permission: true, classroom: nil)
    super(age, name, parent_permission: parent_permission)
    @classroom = classroom
    classroom&.add_student(self)
  end

  def play_hooky
    '¯\\(ツ)/¯'
  end
end
