class Student < User
  has_many :student_enroll_course, dependent: :destroy, foreign_key: 'user_id'
  has_many :courses, through: :student_enroll_course, dependent: :destroy
end
