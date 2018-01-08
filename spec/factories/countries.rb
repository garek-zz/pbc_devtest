FactoryBot.define do
  factory :country do
    country_code do
      loop do
        country_code = SecureRandom.uuid.gsub(/\-/,'')
        break country_code unless Country.exists?(country_code: country_code)
      end
    end

    panel_provider { create(:panel_provider) }

    factory :country_with_dependencies do
      location_groups { 
        [create(:location_group_with_locations, panel_provider: panel_provider),
         create(:location_group_with_locations)]
      }
    end

    factory :country_with_target_groups do
      target_groups {
        [create(:target_group_root, panel_provider: panel_provider),
         create(:target_group_root)]
      }
    end
  end
end
