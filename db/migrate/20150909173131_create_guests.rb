class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.string :first_name
      t.string :last_name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :county
      t.string :zipcode
      t.string :state
      t.string :country

      t.timestamps null: false
    end
  end
end
