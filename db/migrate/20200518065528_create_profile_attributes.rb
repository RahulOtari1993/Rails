class CreateProfileAttributes < ActiveRecord::Migration[5.2]
  def change
    create_table :profile_attributes do |t|
      t.references :campaign, foreign_key: true
      t.string :attribute_name
      t.string :display_name
      t.integer :field_type
      t.boolean :is_active, default: true
      t.boolean :is_custom, default: true

      t.timestamps
    end

    ## Create Profile Attributes for Existing Campaigns
    Campaign.all.each do |campaign|
      profile_attributes = ProfileAttributeService.new(campaign.id)
      profile_attributes.process_records
    end
  end
end
