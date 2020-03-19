class CampaignUser < ApplicationRecord
  ## Associations
  belongs_to :user
  belongs_to :campaign
end
