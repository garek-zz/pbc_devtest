class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :country_code
      t.belongs_to :panel_provider, index: true

      t.timestamps null: false
    end

    add_foreign_key :countries, :panel_providers
  end
end
