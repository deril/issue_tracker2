FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com"}
    password 'password1'
  end

  factory :manager do
    sequence(:email) { |n| "manager#{n}@example.com"}
    password 'password1'
  end

  factory :ticket do
    subject 'Test Subject'
    body 'Test body'
    association :user
    association :manager
  end
end
