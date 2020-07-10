# == Schema Information
#
# Table name: participant_actions
#
#  id              :bigint           not null, primary key
#  participant_id  :bigint
#  points          :integer
#  action_type     :integer
#  title           :string
#  details         :string
#  actionable_id   :integer
#  actionable_type :string
#  user_agent      :text
#  ip_address      :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  coupon          :string
#  campaign_id     :bigint
#
class ParticipantAction < ApplicationRecord
  ## Association
  belongs_to :participant
  belongs_to :campaign

  enum action_type: {sign_up: 0, sign_in: 1, connect: 2, watch_video: 3, visit_url: 4, read_article: 5, quiz: 6, survey: 7, share: 8,
                     recruit: 9, onboarding_questions: 10, location_visit: 11, feed: 12, claim_reward: 13}

  ## Modify JSON Response
  def as_json
    response = super

    if actionable_type.present? && actionable_id.present? && actionable_type.downcase == 'challenge'
      challenge = Challenge.where(id: actionable_id.to_i).first
      challenge_caption = challenge.present? ? challenge.caption : ''

      response = response.merge({:challenge_name => challenge_caption, :reward_name => ''})
    elsif actionable_type.present? && actionable_id.present? && actionable_type.downcase == 'reward'
      reward = Reward.where(id: actionable_id.to_i).first
      reward_name = reward.present? ? reward.name : ''

      response = response.merge({:reward_name => reward_name, :challenge_name => ''})
    else
      response = response.merge({:reward_name => '', :challenge_name => ''})
    end

    response
  end
end
