FactoryBot.define do
  factory :location_group do
    name { Faker::Lorem.word }
    country { create(:country)}
    panel_provider { create(:panel_provider) }

    factory :location_group_with_locations do
      locations { [create(:location), create(:location)] }
    end
  end
end
