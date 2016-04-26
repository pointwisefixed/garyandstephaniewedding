class AddBestFriendBridesmaidToWeddingInfo < ActiveRecord::Migration
  def change
    add_column :wedding_infos, :bestfriendbridesmaid, :text 
  end
end
