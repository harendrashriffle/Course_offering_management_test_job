FactoryBot.define do
  factory :course do
    name { Faker::Educator.subject }
  end
end
