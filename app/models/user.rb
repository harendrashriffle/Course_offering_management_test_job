class User < ApplicationRecord
  validates :name, presence: true
  validates :contact, length: { is: 10 }
  validates :email, presence: true #, uniqueness: true
  validates :role, inclusion: { in: ['Student', 'Instructor', 'Admin']}
end
