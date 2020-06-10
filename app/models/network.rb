# == Schema Information
#
# Table name: networks
#
#  id          :bigint           not null, primary key
#  campaign_id :bigint
#  platform    :integer
#  auth_token  :string
#  username    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Network < ApplicationRecord
  ## Associations
  belongs_to :campaign

  ## ENUM
  enum platform: [ :facebook, :instagram ]

  ## Validations
  validates :campaign_id, :platform, :auth_token, :username, presence: true

end
