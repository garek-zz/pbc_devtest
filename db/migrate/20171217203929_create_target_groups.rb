class CreateTargetGroups < ActiveRecord::Migration
  def change
    create_table :target_groups do |t|
      t.string :name
      t.string :external_id
      t.belongs_to :parent, index: true
      t.string :secret_code
      t.belongs_to :panel_provider, index: true

      t.timestamps null: false
    end

    add_foreign_key :target_groups, :target_groups
    add_foreign_key :target_groups, :panel_providers
  end
end
