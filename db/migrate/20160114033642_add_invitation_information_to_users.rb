class AddInvitationInformationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :attending, :boolean
    add_column :users, :plusone, :boolean
  end
end
