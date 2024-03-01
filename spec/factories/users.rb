FactoryBot.define do
  factory :user do
    name     { Faker::Name.name }
    email    { Faker::Internet.email}
    # contact  { Faker::PhoneNumber.subscriber_number(length: 10) }
    password_digest     {Faker::Internet.password(min_length: 6)}
    type     {['Admin','Student','Instructor'].sample}
  end
end
