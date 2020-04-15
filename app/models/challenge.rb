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
#  description :text
#  reward_type :integer
#  reward_id   :bigint
#
class Challenge < ApplicationRecord
  ## Associations
  belongs_to :campaign

  MECHANISMS = %w(like rate form scorm login video share pixel manual signup follow article referal
                  comment connect hashtag referal location subscribe submission play practice hr link)

  enum reward_type: [:points, :prize]

  ## Validations
  validates :mechanism, :name, :link, :description, presence: true
end
