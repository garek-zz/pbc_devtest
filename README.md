# Getting Started

1. Install Bundler at the command prompt if you haven't yet:

        $ gem install bundler
        
2. Change directory to 'pbc_devtest' and at the command prompt

        $ bundle install
        
3. Create database

        $ rake db:create
        
4. Run migrations

        $ rake db:migrate
        
5. If you want load examples data

        $ rake db:seed
        
7. Start the web server

        $ rails server

6. If you loaded seeds, you can see all needed data for example request to private and public endpoints

    * Public API:

          $ curl 'localhost:3000/api/public/v1/locations/PL'
          $ curl 'localhost:3000/api/public/v1/target_groups/PL'
        
    * Private API (if you run seeds you can find at the end of command line client_key):
    
          $ curl -H "Authorization: Token @client_key" 'localhost:3000/api/private/v1/locations/PL'
          $ curl -H "Authorization: Token @client_key" 'localhost:3000/api/private/v1/target_groups/PL'
          $ curl -H "Authorization: Token @client_key" -H "Content-Type: application/json" -X POST -d '{"country_code": "PL", "target_group_id": 1, "locations": [{"id": 1, "panel_size": 200}]}' 'localhost:3000/api/private/v1/evaluate_target'
