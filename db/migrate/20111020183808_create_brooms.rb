class CreateBrooms < ActiveRecord::Migration
  def change
    create_table :brooms do |t|
      t.references :user
      t.string :period
      t.text :labels

      t.timestamps
    end
    add_index :brooms, :user_id
  end
end
