class CreateParticipantProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :participant_profiles do |t|
      t.references :participant, foreign_key: true
      t.references :profile_attribute, foreign_key: true
      t.string :value

      t.timestamps
    end

    ProfileAttribute.where(display_name: 'Multiple Choice').delete_all
    ProfileAttribute.where(display_name: 'Check Boxes').delete_all
  end
end
