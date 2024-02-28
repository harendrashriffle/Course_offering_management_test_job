class Course < ApplicationRecord
  belongs_to :admin, class_name: "User"
  has_many :student_enroll_courses
  has_many :student, through: :student_enroll_courses

  validates :name, presence: true
end
