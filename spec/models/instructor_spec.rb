require 'rails_helper'

RSpec.describe Instructor, type: :model do
  describe 'association' do
    it { should have_one(:course).through(:instructor_assignee_course) }
  end
end
