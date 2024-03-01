require 'rails_helper'

RSpec.describe InstructorAssigneeCourse, type: :model do
  # describe 'validations' do
  #   it { should validate_uniqueness_of(:user_id) }
  # end

  describe 'associations' do
    it { should belong_to(:instructor) }
    it { should belong_to(:course) }
  end
end
