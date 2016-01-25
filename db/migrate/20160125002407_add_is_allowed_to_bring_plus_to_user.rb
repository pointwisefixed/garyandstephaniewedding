class AddIsAllowedToBringPlusToUser < ActiveRecord::Migration
  def change
    add_column :users, :can_bring_plus_one, :boolean, :default => true
  end
end
