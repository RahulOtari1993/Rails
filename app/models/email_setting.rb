# == Schema Information
#
# Table name: email_settings
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :string
#  campaign_id :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class EmailSetting < ApplicationRecord
  ## Associations
  belongs_to :campaign
  has_many :participants
end
