# == Schema Information
#
# Table name: networks
#
#  id               :bigint           not null, primary key
#  campaign_id      :bigint
#  platform         :integer
#  auth_token       :string
#  username         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  organization_id  :integer
#  uid              :string
#  email            :string
#  expires_at       :datetime
#  avatar           :string
#
class Network < ApplicationRecord
  ## Associations
  belongs_to :campaign

  ## ENUM
  enum platform: [ :facebook, :instagram ]

  ## Validations
  validates :campaign_id, :platform, :username, presence: true

  ## Mount Uploader for File Upload
  mount_uploader :avatar, AvatarUploader


end
