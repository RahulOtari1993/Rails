# == Schema Information
#
# Table name: participant_device_tokens
#
#  id             :bigint           not null, primary key
#  participant_id :integer
#  os_type        :string
#  os_version     :string
#  device_id      :string
#  token          :string
#  token_type     :string
#  device_arn     :string
#  app_version    :string
#  state          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class ParticipantDeviceToken < ApplicationRecord
  ## Associations
  belongs_to :participant
end
