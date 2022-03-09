# == Schema Information
#
# Table name: businesses
#
#  id              :bigint           not null, primary key
#  name            :string
#  address         :string
#  logo            :string
#  working_hours   :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#  campaign_id     :integer
#


class Business < ApplicationRecord

  ## Mount Uploader for File Upload
  mount_uploader :logo, LogoUploader

  ## Tags
  acts_as_taggable_on :tags
  
  #Associations
  belongs_to :campaign
  has_many :offers, dependent: :destroy
  # belongs_to :organization

  ## Validations
  # validates :name, :address, :logo, :working_hours, presence: true
end
