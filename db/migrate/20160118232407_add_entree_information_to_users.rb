class AddEntreeInformationToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :entree, index: true, foreign_key: true
    add_column :users, :plus_one_entree_id, :integer
		add_index :users, :plus_one_entree_id
  end
end
