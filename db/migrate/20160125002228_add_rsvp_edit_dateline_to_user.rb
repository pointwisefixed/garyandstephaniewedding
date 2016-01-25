class AddRsvpEditDatelineToUser < ActiveRecord::Migration
  def change
    add_column :users, :rsvp_edit_dateline, :timestamp
  end
end
