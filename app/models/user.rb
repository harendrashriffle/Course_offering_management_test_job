class User < ApplicationRecord
  validates :name, presence: true, length: {minimum: 3}
  validates :password_digest, presence: true, length: { minimum: 6 }
  validates :email, presence: true , uniqueness: {case_sensitive: false}
  validates :type, inclusion: { in: ['Student', 'Instructor', 'Admin']}
end
