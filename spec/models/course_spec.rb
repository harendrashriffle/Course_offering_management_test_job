require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should belong_to(:admin) }
    it { should have_many(:student).through(:student_enroll_courses) }
    it { should have_one(:instructor).through(:instructor_assignee_course) }
  end
end
