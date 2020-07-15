class RenameActionableToShareableForSocialShareVisits < ActiveRecord::Migration[5.2]
  def change
    rename_column :social_share_visits, :actionable_id, :shareable_id
    rename_column :social_share_visits, :actionable_type, :shareable_type
  end
end
