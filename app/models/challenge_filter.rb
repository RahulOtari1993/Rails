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
  EVENTS = %w(age tags gender current-points lifetime-points challenge login) #rewards platforms
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
      when 'current-points' then
        current_points_check(participant)
      when 'lifetime-points' then
        lifetime_points_check(participant)
      when 'rewards' then
        rewards_check(participant)
      when 'platforms' then
        platform_check(participant)
      when 'challenge' then
        challenge_check(participant)
      when 'login' then
        login_check(participant)
    end
  end

  ## Check Age Conditions
  def age_check participant
    true
  end

  ## Check Tags Conditions
  def tags_check participant
    tags = participant.tags.pluck(:name)
    if self.challenge_condition == 'has'
      tags.include?(challenge_value)
    else
      !tags.include?(challenge_value)
    end
  end

  ## Check Gender Conditions
  def gender_check participant
    self.challenge_value == participant.gender
  end

  ## Check Unused Points Conditions
  def current_points_check participant
    case self.challenge_condition
      when 'equals' then
        participant.unused_points.to_i == self.challenge_value.to_i
      when 'greater_than' then
        participant.unused_points.to_i > self.challenge_value.to_i
      when 'less_than' then
        participant.unused_points.to_i < self.challenge_value.to_i
      when 'greater_than_or_equal' then
        participant.unused_points.to_i >= self.challenge_value.to_i
      when 'less_than_or_Equal' then
        participant.unused_points.to_i <= self.challenge_value.to_i
      else
        false
    end
  end

  ## Check Unused Points Conditions
  def lifetime_points_check participant
    case self.challenge_condition
      when 'equals' then
        participant.points.to_i == self.challenge_value.to_i
      when 'greater_than' then
        participant.points.to_i > self.challenge_value.to_i
      when 'less_than' then
        participant.points.to_i < self.challenge_value.to_i
      when 'greater_than_or_equal' then
        participant.points.to_i >= self.challenge_value.to_i
      when 'less_than_or_Equal' then
        participant.points.to_i <= self.challenge_value.to_i
      else
        false
    end
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
    case self.challenge_condition
    when 'equals' then
      participant.completed_challenges.to_i == self.challenge_value.to_i
    when 'greater_than' then
      participant.completed_challenges.to_i > self.challenge_value.to_i
    when 'less_than' then
      participant.completed_challenges.to_i < self.challenge_value.to_i
    when 'greater_than_or_equal' then
      participant.completed_challenges.to_i >= self.challenge_value.to_i
    when 'less_than_or_Equal' then
      participant.completed_challenges.to_i <= self.challenge_value.to_i
    else
      false
    end
  end

  ## Check Login Conditions
  def login_check participant
    case self.challenge_condition
    when 'equals' then
      participant.sign_in_count.to_i == self.challenge_value.to_i
    when 'greater_than' then
      participant.sign_in_count.to_i > self.challenge_value.to_i
    when 'less_than' then
      participant.sign_in_count.to_i < self.challenge_value.to_i
    when 'greater_than_or_equal' then
      participant.sign_in_count.to_i >= self.challenge_value.to_i
    when 'less_than_or_Equal' then
      participant.sign_in_count.to_i <= self.challenge_value.to_i
    else
      false
    end
  end
end
