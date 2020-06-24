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
#
class ParticipantAction < ApplicationRecord
  ## Association
  belongs_to :participant

  enum action_type: {sign_up: 0, sign_in: 1, watch_video: 3, visit_url: 4, read_article: 5, quiz: 6, survey: 7, share: 8,
                     recruit: 9, onboarding_questions: 10, location_visit: 11, feed: 12, claim_reward: 13 }
end
