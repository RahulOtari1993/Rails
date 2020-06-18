# == Schema Information
#
# Table name: reward_filters
#
#  id               :bigint           not null, primary key
#  reward_id        :bigint
#  reward_condition :string
#  reward_value     :string
#  reward_event     :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class RewardFilter < ApplicationRecord
  belongs_to :reward

	EVENTS = %w(age tags gender current-points lifetime-points challenge login) #rewards platforms
  CONDITIONS = %w(equals greater_than less_than greater_than_or_equal less_than_or_Equal)
  SOCIAL_PLATFORMS = %w(facebook twitter google instagram youtube)
  # serialize :reward_event, :reward_value, :reward_condition

  validates :reward_value, presence: true
  validates :reward_event, presence: true, inclusion: RewardFilter::EVENTS
  validates :reward_condition, presence: true, inclusion: RewardFilter::CONDITIONS, if: Proc.new { |x| ["age", "points"].include?(x.reward_event) }

  ## Check if Reward Filter is Applicable for Participant & Reward
  def available? participant
    case self.reward_event
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
    case self.reward_condition
      when 'equals' then
        participant.age.to_i == self.reward_value.to_i
      when 'greater_than' then
        participant.age.to_i > self.reward_value.to_i
      when 'less_than' then
        participant.age.to_i < self.reward_value.to_i
      when 'greater_than_or_equal' then
        participant.age.to_i >= self.reward_value.to_i
      when 'less_than_or_Equal' then
        participant.age.to_i <= self.reward_value.to_i
      else
        false
    end
  end

  ## Check Tags Conditions
  def tags_check participant
    tags = participant.tags.pluck(:name)
    if self.reward_condition == 'has'
      tags.include?(reward_value)
    else
      !tags.include?(reward_value)
    end
  end

  ## Check Gender Conditions
  def gender_check participant
    self.reward_value == participant.gender
  end

  ## Check Unused Points Conditions
  def current_points_check participant
    case self.reward_condition
      when 'equals' then
        participant.unused_points.to_i == self.reward_value.to_i
      when 'greater_than' then
        participant.unused_points.to_i > self.reward_value.to_i
      when 'less_than' then
        participant.unused_points.to_i < self.reward_value.to_i
      when 'greater_than_or_equal' then
        participant.unused_points.to_i >= self.reward_value.to_i
      when 'less_than_or_Equal' then
        participant.unused_points.to_i <= self.reward_value.to_i
      else
        false
    end
  end

  ## Check Unused Points Conditions
  def lifetime_points_check participant
    case self.reward_condition
      when 'equals' then
        participant.points.to_i == self.reward_value.to_i
      when 'greater_than' then
        participant.points.to_i > self.reward_value.to_i
      when 'less_than' then
        participant.points.to_i < self.reward_value.to_i
      when 'greater_than_or_equal' then
        participant.points.to_i >= self.reward_value.to_i
      when 'less_than_or_Equal' then
        participant.points.to_i <= self.reward_value.to_i
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

  ## Check Completed Challenges Conditions
  def challenge_check participant
    case self.reward_condition
      when 'equals' then
        participant.completed_challenges.to_i == self.reward_value.to_i
      when 'greater_than' then
        participant.completed_challenges.to_i > self.reward_value.to_i
      when 'less_than' then
        participant.completed_challenges.to_i < self.reward_value.to_i
      when 'greater_than_or_equal' then
        participant.completed_challenges.to_i >= self.reward_value.to_i
      when 'less_than_or_Equal' then
        participant.completed_challenges.to_i <= self.reward_value.to_i
      else
        false
    end
  end

  ## Check Login Conditions
  def login_check participant
    case self.reward_condition
      when 'equals' then
        participant.sign_in_count.to_i == self.reward_value.to_i
      when 'greater_than' then
        participant.sign_in_count.to_i > self.reward_value.to_i
      when 'less_than' then
        participant.sign_in_count.to_i < self.reward_value.to_i
      when 'greater_than_or_equal' then
        participant.sign_in_count.to_i >= self.reward_value.to_i
      when 'less_than_or_Equal' then
        participant.sign_in_count.to_i <= self.reward_value.to_i
      else
        false
    end
  end
end
