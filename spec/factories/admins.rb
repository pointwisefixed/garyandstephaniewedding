FactoryBot.define do
  factory :admin do
    sequence(:email) { |n| "admin#{n}@example.com" }
    password { "admin_password123" }
    password_confirmation { "admin_password123" }
  end
end
