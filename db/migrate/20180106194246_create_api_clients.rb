class CreateApiClients < ActiveRecord::Migration
  def change
    create_table :api_clients do |t|
      t.string :client_key

      t.timestamps null: false
    end
  end
end
