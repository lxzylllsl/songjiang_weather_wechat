class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :description
      t.datetime :datetime
      t.string :author
      t.text :content
      t.attachment :picture

      t.timestamps null: false
    end
    add_index :articles, :title, unique: true
  end
end
