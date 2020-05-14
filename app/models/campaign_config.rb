# == Schema Information
#
# Table name: campaign_configs
#
#  id                   :bigint           not null, primary key
#  campaign_id          :bigint
#  facebook_app_id      :string
#  facebook_app_secret  :string
#  google_client_id     :string
#  google_client_secret :string
#  twitter_app_id       :string
#  twitter_app_secret   :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class CampaignConfig < ApplicationRecord
  ## Associations
  belongs_to :campaign
end
