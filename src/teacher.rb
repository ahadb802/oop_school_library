require_relative './person'

class Teacher < Person
  attr_reader :specialization

  def initialize(age, specialization, name, type, parent_permission: true)
    super(age, name, type, parent_permission: parent_permission)
    @specialization = specialization
  end

  def can_use_services?
    true
  end
end
