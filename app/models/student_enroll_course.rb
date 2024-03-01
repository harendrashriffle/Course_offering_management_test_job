class StudentEnrollCourse < ApplicationRecord
  belongs_to :student, foreign_key: 'user_id'
  belongs_to :course, foreign_key: 'course_id'

  validates :user_id, uniqueness: {message:"student has already enrolled in this course"}
end
