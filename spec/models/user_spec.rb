require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3) }
    it { should validate_presence_of(:contact) }
    it { should validate_uniqueness_of(:contact) }
    # it { should validate_length_of(:contact).is_equal_to(10)}
    it { should validate_presence_of(:email)}
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_inclusion_of(:type).in_array(['Student','Instructor','Admin'])}
  end
end
