class CreateJoinTableLocationsLocationGroups < ActiveRecord::Migration
  def change
    create_join_table :locations, :location_groups do |t|
      t.index :location_id
      t.index :location_group_id
    end
  end
end
