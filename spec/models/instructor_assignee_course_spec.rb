require 'rails_helper'

RSpec.describe InstructorAssigneeCourse, type: :model do
  describe 'associations' do
    it { should belong_to(:instructor) }
    it { should belong_to(:course) }
  end
end
