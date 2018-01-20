PriceLogic::Configuration.config do |config|
  config.array_counter_url     = 'http://openlibrary.org/search.json?q=the+lord+of+the+rings'
  config.character_counter_url = 'http://time.com'
  config.html_node_counter_url = 'http://time.com'
  config.rest_of               = 100
end