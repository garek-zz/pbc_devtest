require 'securerandom'

def create_target_group(level, panel_provider, country, parent=nil)
  target_group = TargetGroup.create(panel_provider: panel_provider,
                                    parent: parent,
                                    secret_code: SecureRandom.hex,
                                    external_id: SecureRandom.hex,
                                    name: "Target group #{rand(2<<16)}")

  target_group.countries << country unless parent
  puts "Created root TargetGroup: target_group_id => #{target_group.id}" unless parent
  return if level < 1

  3.times {create_target_group(level - 1, panel_provider, country, parent=target_group)} 
end


def create_country(panel_provider, country_code)
  country = panel_provider.countries.build(country_code: country_code)
  country.save
  puts "Created Country: country_code: #{country.country_code}"
  country
end

def create_panel_provider(code, price_type)
  panel_provider  = PanelProvider.create(code: code, price_type: price_type)
  puts "Created PanelProvider: price_type => #{panel_provider.price_type}"
  panel_provider
end

def create_location_group(panel_provider, country, name)
  location_group = panel_provider.location_groups.build(country: country, name: 'Radomskie')
  location_group.save
  puts "Created LocationGroup: name => #{location_group.name}"
end

def create_api_client
  api_client = ApiClient.create
  puts "Client key: #{api_client.client_key}"
end

def create_location
  ->(name) {
    location = Location.create( name: name,
                                external_id: SecureRandom.hex,
                                secret_code: SecureRandom.hex)

    puts "Created Location: location_id => #{location.id}"
    location
  }
end

def connect_locations_with_location_groups
  Location.all.each_slice(LocationGroup.count) do |locations|
    LocationGroup.all.each_with_index do |location_group, index|
      location_group.locations << locations[index] if locations[index]
    end
  end
end

[ 'Warszawa', 'Krawków', 'Bieniewice', 'Gdańsk', 'London', 'Berlin',
  'Powiat Warszawa-Zachód', 'Powiat Łomianki', 'Ursynów', 'Wrocław',
  'Szczecin', 'Sosnowiec', 'Radom', 'Kielce', 'Suwałki', 'Rudawka',
  'Zakopane', 'Poanań', 'Hel', 'Hull'
].map(&create_location)

panel_provider  = create_panel_provider("Test1", 'PRICE_ARRAY')
country         = create_country(panel_provider, 'PL')
create_location_group(panel_provider, country, 'Radomskie')
create_location_group(panel_provider, country, 'Kieleckie')
create_target_group(3, panel_provider, country)
create_target_group(3, panel_provider, country)

panel_provider  = create_panel_provider("Test2", 'PRICE_CHAR')
country         = create_country(panel_provider, 'DE')
create_location_group(panel_provider, country, 'Bavaria')
create_target_group(3, panel_provider, country)

panel_provider = create_panel_provider("Test3", 'PRICE_NODE')
country        = create_country(panel_provider, 'UK')
create_location_group(panel_provider, country, 'Yorkshire')
create_target_group(3, panel_provider, country)

connect_locations_with_location_groups
create_api_client
