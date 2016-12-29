class CreateAqiInfos < ActiveRecord::Migration
  def change
    create_table :aqi_infos do |t|
      t.string :info

      t.timestamps null: false
    end
  end
end
