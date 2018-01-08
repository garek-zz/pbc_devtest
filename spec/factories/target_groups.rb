FactoryBot.define do
  factory :target_group do
    factory :target_group_leaf do
      parent_id { create(:target_group_root).id }
    end

    factory :target_group_root do
      parent_id nil
    end

    factory :target_group_with_countries do
      parent_id nil
      countries { [create(:country), create(:country)] }
    end

    factory :target_group_without_countries do
      parent_id nil
      countries []
    end

    name { Faker::Lorem.word }
    external_id { Faker::Code.imei }
    panel_provider_id { create(:panel_provider).id }
    secret_code do
      loop do
        secret_code = SecureRandom.uuid.gsub(/\-/,'')
        break secret_code unless TargetGroup.exists?(secret_code: secret_code)
      end
    end
  end
end
