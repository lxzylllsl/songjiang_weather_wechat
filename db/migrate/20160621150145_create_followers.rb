class CreateFollowers < ActiveRecord::Migration
  def change
    create_table :followers, :id => false do |t|
      t.string :openid, length: 32, null: false
      t.string :nick_name
      t.integer :sex
      t.string :province
      t.string :country
      t.string :headimgurl

      t.timestamps null: false
    end
    add_index :followers, :openid, unique: true
  end
end
