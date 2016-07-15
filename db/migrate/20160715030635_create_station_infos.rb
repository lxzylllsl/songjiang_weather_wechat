class CreateStationInfos < ActiveRecord::Migration
  def change
    create_table :station_infos do |t|
      t.string :sitenumber
      t.string :name
      t.string :area
      t.string :sitetype
      t.string :address
      t.float :lon
      t.float :lat
      
      t.timestamps null: false
    end
    add_index :station_infos, :sitenumber, unique: true
  end
end
