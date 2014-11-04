# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email_address Faker::Internet.email
    password Faker::Internet.password(8)
  end
end
