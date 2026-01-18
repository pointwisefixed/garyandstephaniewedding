FactoryBot.define do
  factory :wedding_info do
    his_story { "His story content" }
    her_story { "Her story content" }
    proposal { "The proposal story" }
    ceremony_location { "Beautiful Chapel" }
    reception_location { "Grand Ballroom" }
    accommodations { "Hotel information" }
    registry_info { "Registry details" }
  end
end
