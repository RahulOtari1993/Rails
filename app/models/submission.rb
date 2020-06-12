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
#  user_agent     :text
#  ip_address     :string
#
class Submission < ApplicationRecord
  ## Associations
  belongs_to :participant
  belongs_to :campaign
  belongs_to :challenge

  ## Callbacks
  after_create :submission_count_change

  private

  ## Increase Challenge Submission Counter
  def submission_count_change
    challenge = self.challenge
    if challenge.present?
      count = challenge.completions + 1
      challenge.update_attribute(:completions, count)
    end
  end
end
