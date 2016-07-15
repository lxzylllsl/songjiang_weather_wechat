class CreatePoems < ActiveRecord::Migration
  def change
    create_table :poems do |t|
      t.string :content
      t.string :author
      
      t.timestamps null: false
    end
  end
end
