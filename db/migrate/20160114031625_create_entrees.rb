class CreateEntrees < ActiveRecord::Migration
  def change
    create_table :entrees do |t|
      t.string :name
      t.text :description
      t.integer :order

      t.timestamps null: false
    end
  end
end
