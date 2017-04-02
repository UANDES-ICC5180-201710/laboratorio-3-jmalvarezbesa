class Person < ApplicationRecord
  has_many :enrollements, through: :enrollments
  validates_presence_of :first_name, :last_name, :email

  def to_s
    return first_name + ' ' + last_name
  end
end
