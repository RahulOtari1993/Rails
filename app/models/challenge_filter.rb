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
  EVENTS = %w(age tags gender points rewards platforms challenge)
  CONDITIONS = %w(equals greater_than less_than greater_than_or_equal less_than_or_Equal)
  SOCIAL_PLATFORMS = %w(facebook twitter google instagram youtube)

  ## Validations
  # validates :challenge_event, :challenge_condition, :challenge_value, presence: true
end
