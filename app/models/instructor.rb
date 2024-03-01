class Instructor < User
  has_one :instructor_assignee_course, foreign_key: 'user_id'
  has_one :course, through: :instructor_assignee_course
end
