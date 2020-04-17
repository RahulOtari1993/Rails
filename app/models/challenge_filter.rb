# == Schema Information
#
# Table name: challenge_filters
#
#  id                  :bigint           not null, primary key
#  challenge_id        :bigint
#  challenge_event     :string
#  challenge_condition :string
#  challenge_value     :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class ChallengeFilter < ApplicationRecord

  ## Associations
  belongs_to :challenge

  ## Constants
  EVENTS = %w(Age Tags Gender Points Rewards Platforms)
  AGE_CONDITIONS = %w(Equals Greater\ Than Less\ Than Greater\ Than\ or\ Equal Less\ Than\ or\ Equal)
  SOCIAL_PLATFORMS = %w(Facebook Twitter Google+ Instagram Youtube)

  ## Validations
  validates :challenge_event, :challenge_condition, :challenge_value, presence: true
end
