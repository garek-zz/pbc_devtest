require 'securerandom'

def create_target_group(level, panel_provider, parent=nil)
  target_group = TargetGroup.create(panel_provider: panel_provider,
                                    parent: parent,
                                    secret_code: SecureRandom.hex,
                                    external_id: SecureRandom.hex,
                                    name: "Target group #{rand(2<<16)}")

  return if level < 1

  3.times {create_target_group(level - 1, panel_provider, parent=target_group)} 
end

[ 'Warszawa', 'Krawków', 'Bieniewice', 'Gdańsk', 'London', 'Berlin',
  'Powiat Warszawa-Zachód', 'Powiat Łomianki', 'Ursynów', 'Wrocław',
  'Szczecin', 'Sosnowiec', 'Radom', 'Kielce', 'Suwałki', 'Rudawka',
  'Zakopane', 'Poanań', 'Hel', 'Hull'
].each do |location_name|
  Location.create(name: location_name,
                  external_id: SecureRandom.hex,
                  secret_code: SecureRandom.hex)
end

panel_provider  = PanelProvider.create(code: "Test1", price_type: 'PRICE_ARRAY')
country = panel_provider.countries.build(country_code: 'PL')
country.save
panel_provider.location_groups.build(country: country, name: 'Radomskie').save
panel_provider.location_groups.build(country: country, name: 'Kieleckie').save
create_target_group(3, panel_provider)
create_target_group(3, panel_provider)

panel_provider  = PanelProvider.create(code: "Test2", price_type: 'PRICE_CHAR')
country         = panel_provider.countries.build(country_code: 'DE')
country.save
panel_provider.location_groups.build(country: country, name: 'Bavaria').save
create_target_group(3, panel_provider)

panel_provider = PanelProvider.create(code: "Test3", price_type: 'PRICE_NODE')
country        = panel_provider.countries.build(country_code: 'UK')
country.save
panel_provider.location_groups.build(country: country, name: 'Yorkshire').save
create_target_group(3, panel_provider)
