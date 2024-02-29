class StudentEnrollCourse < ApplicationRecord
  belongs_to :student, foreign_key: 'user_id'
  belongs_to :course, foreign_key: 'course_id'
end
