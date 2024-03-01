class InstructorAssigneeCourse < ApplicationRecord
  belongs_to :instructor, foreign_key: 'user_id'
  belongs_to :course, foreign_key: 'course_id'

  validates :user_id, uniqueness: {message:"instructor can only assign in one course"}
end
