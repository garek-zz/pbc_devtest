FactoryBot.define do
  factory :panel_provider do
    code do
      loop do
        code = SecureRandom.uuid.gsub(/\-/,'')
        break code unless PanelProvider.exists?(code: code)
      end
    end

    price_type { PanelProvider::PRICE_TYPES.keys.first }

    factory :panel_provider_with_fake_price_type do
      price_type { 'fake_type' + Faker::Code.asin }
    end

    factory :panel_provider_with_empty_price_type do
      price_type nil
    end
  end
end
