class CreateCampaignsParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :campaigns_participants do |t|
     	t.belongs_to :campaign
      	t.belongs_to :participant
    end
  end
end
