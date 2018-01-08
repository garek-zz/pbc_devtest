FactoryBot.define do
  factory :location do
    name { Faker::Lorem.word }
    external_id { Faker::Code.imei }
    secret_code do
      loop do
        secret_code = SecureRandom.uuid.gsub(/\-/,'')
        break secret_code unless Location.exists?(secret_code: secret_code)
      end
    end
  end
end
