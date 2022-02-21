class AddSportIdToAnnouncements < ActiveRecord::Migration[5.2]
  def change
    add_column :announcements, :sport_id, :integer
    add_index :announcements, :sport_id
  end
end
