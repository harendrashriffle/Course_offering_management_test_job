class Course < ApplicationRecord
  belongs_to :admin, foreign_key: 'user_id'
  has_many :student_enroll_courses
  has_many :students, through: :student_enroll_courses
  has_one :instructor_assignee_course
  has_one :instructor, through: :instructor_assignee_course

  validates :name, presence: true
end
