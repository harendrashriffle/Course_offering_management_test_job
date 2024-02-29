class Instructor < User
  has_many :instructor_assignee_course, foreign_key: 'user_id'
  has_many :courses, through: :instructor_assignee_course
end
