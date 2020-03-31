# == Schema Information
#
# Table name: campaign_users
#
#  id          :bigint           not null, primary key
#  user_id     :bigint
#  campaign_id :bigint
#  role        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class CampaignUser < ApplicationRecord
  ## Associations
  belongs_to :user
  belongs_to :campaign

  enum role: [:participant, :admin]
end
