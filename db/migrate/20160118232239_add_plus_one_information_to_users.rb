class AddPlusOneInformationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :plus_one_first_name, :string
    add_column :users, :plust_one_last_name, :string
  end
end
