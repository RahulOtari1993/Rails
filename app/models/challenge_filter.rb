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
  validates :challenge_event, :challenge_condition, :challenge_value, presence: true

  ## Check if Challenge Filter is Applicable for Participant & Challenge
  def available? participant
    case self.challenge_event
      when 'age' then
        age_check(participant)
      when 'tags' then
        tags_check(participant)
      when 'gender' then
        gender_check(participant)
      when 'points' then
        points_check(participant)
      when 'rewards' then
        rewards_check(participant)
      when 'platforms' then
        platform_check(participant)
      when 'challenge' then
        challenge_check(participant)
    end
  end

  ## Check Age Conditions
  def age_check participant
    true
  end

  ## Check Tags Conditions
  def tags_check participant
    true
  end

  ## Check Gender Conditions
  def gender_check participant
    self.challenge_value == participant.gender
  end

  ## Check Points Conditions
  def points_check participant
    true
  end

  ## Check Rewards Conditions
  def rewards_check participant
    true
  end

  ## Check Platform Conditions
  def platform_check participant
    true
  end

  ## Check Challenge Conditions
  def challenge_check participant
    true
  end
end
