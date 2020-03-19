# == Schema Information
#
# Table name: challenges
#
#  id          :bigint           not null, primary key
#  campaign_id :bigint
#  name        :text
#  platform_id :integer
#  start       :datetime
#  finish      :datetime
#  timezone    :string
#  points      :integer
#  parameters  :string
#  mechanism   :string
#  feature     :boolean
#  creator_id  :integer
#  approver_id :integer
#  content     :text
#  link        :text
#  clicks      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Challenge < ApplicationRecord
  ## Associations
  belongs_to :campaign
end
