# == Schema Information
#
# Table name: networks
#
#  id              :bigint           not null, primary key
#  campaign_id     :bigint
#  platform        :integer
#  auth_token      :string
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#  uid             :string
#  email           :string
#  expires_at      :datetime
#  avatar          :string
#  is_disconnected :boolean          default(FALSE)
#
class Network < ApplicationRecord
  ## Associations
  belongs_to :campaign
  belongs_to :organization

  has_many :network_pages, dependent: :destroy
  has_many :network_page_posts, dependent: :destroy

  ## ENUM
  enum platform: [ :facebook, :instagram ]

  ## Validations
  validates :campaign_id, :platform, presence: true

  ## Mount Uploader for File Upload
  mount_uploader :avatar, AvatarUploader

  ## scopes
  # scope :current_active, -> { where("auth_token IS NOT NULL AND expires_at > ?", Time.now) }
  scope :current_active, -> { where(is_disconnected: false) }

end
