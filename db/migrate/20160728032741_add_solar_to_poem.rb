class AddSolarToPoem < ActiveRecord::Migration
  def change
    add_column :poems, :solar, :string
  end
end
