FactoryBot.define do
  factory :entree do
    sequence(:name) { |n| "Entree #{n}" }
    description { "A delicious meal option" }

    trait :vegetarian do
      name { "Vegetarian Option" }
      description { "A delicious vegetarian meal" }
    end

    trait :meat do
      name { "Meat Option" }
      description { "A delicious meat-based meal" }
    end
  end
end
