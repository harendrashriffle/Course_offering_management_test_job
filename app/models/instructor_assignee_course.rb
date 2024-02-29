class InstructorAssigneeCourse < ApplicationRecord
  belongs_to :instructor, foreign_key: 'user_id'
  belongs_to :course, foreign_key: 'course_id'
end
