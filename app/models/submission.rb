# == Schema Information
#
# Table name: submissions
#
#  id             :bigint           not null, primary key
#  campaign_id    :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  participant_id :bigint
#  challenge_id   :bigint
#  useragent      :text
#  ipaddress      :string
#
class Submission < ApplicationRecord
  ## Associations
  belongs_to :participant
  belongs_to :campaign
end
