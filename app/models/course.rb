class Course < ApplicationRecord
  has_many :enrollments
  has_many :students, through: :enrollments
  belongs_to :teacher, class_name: 'Person', foreign_key: 'person_id'
  validates_presence_of :title, :code, :teacher, :quota

  def to_s
    return title
  end
end
