FactoryGirl.define do
  factory :user do
     full_name { Faker::Name.name }
     nickname { Faker::Name.first_name }
     email_address { Faker::Internet.email }
     password 'password'
     password_confirmation 'password'
     admin { false }

     factory :admin do
       full_name { Faker::Name.name }
       nickname { Faker::Name.first_name }
       email_address { Faker::Internet.email }
       password 'password'
       password_confirmation 'password'
       admin { true }
     end

     factory :invalid_user do
       full_name nil
       nickname nil
       email_address nil
       password nil
       password_confirmation nil
       admin nil
     end
  end
end
