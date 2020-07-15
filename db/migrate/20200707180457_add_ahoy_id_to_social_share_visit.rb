class AddAhoyIdToSocialShareVisit < ActiveRecord::Migration[5.2]
  def change
    add_column :social_share_visits, :ahoy_visit_id, :integer
  end
end
