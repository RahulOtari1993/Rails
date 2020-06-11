class AddSubmissionColumnToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :points, :integer, default: 0
    add_column :participants, :unused_points, :integer, default: 0
    add_column :participants, :clicks, :integer, default: 0
    add_column :participants, :likes, :integer, default: 0
    add_column :participants, :comments, :integer, default: 0
    add_column :participants, :reshares, :integer, default: 0
    add_column :participants, :recruits, :integer, default: 0
    add_column :participants, :connect_type, :integer
  end
end
