FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    first_name { "John" }
    last_name { "Doe" }
    attending { false }
    plusone { false }
    can_bring_plus_one { false }
    admin { false }

    trait :attending do
      attending { true }
    end

    trait :with_plus_one do
      plusone { true }
      can_bring_plus_one { true }
      plus_one_first_name { "Jane" }
      plus_one_last_name { "Doe" }
    end

    trait :admin do
      admin { true }
    end

    trait :with_entree do
      association :entree
    end

    trait :with_plus_one_entree do
      association :plus_one_entree, factory: :entree
    end
  end
end
