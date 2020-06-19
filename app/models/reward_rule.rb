# == Schema Information
#
# Table name: reward_rules
#
#  id             :bigint           not null, primary key
#  rule_type      :string
#  reward_id      :bigint
#  rule_condition :string
#  rule_value     :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class RewardRule < ApplicationRecord
  belongs_to :reward
  RULES = %w[challenges_completed number_of_logins points recruits]
	CONDITIONS = %w(equals greater_than less_than greater_than_or_equal less_than_or_Equal)

  ## Check if Participant is Eligible for Reward
  def eligible? participant
    case self.rule_type
      when 'challenges_completed' then
        challenges_completed_check(participant)
      when 'number_of_logins' then
        logins_check(participant)
      when 'points' then
        points_check(participant)
      when 'recruits' then
        recruits_check(participant)
    end
  end

  ## Check Completed Challenges Conditions
  def challenges_completed_check participant
    case self.rule_condition
      when 'equals' then
        participant.completed_challenges.to_i == self.rule_value.to_i
      when 'greater_than' then
        participant.completed_challenges.to_i > self.rule_value.to_i
      when 'less_than' then
        participant.completed_challenges.to_i < self.rule_value.to_i
      when 'greater_than_or_equal' then
        participant.completed_challenges.to_i >= self.rule_value.to_i
      when 'less_than_or_Equal' then
        participant.completed_challenges.to_i <= self.rule_value.to_i
      else
        false
    end
  end

  ## Check Login Conditions
  def logins_check participant
    case self.rule_condition
      when 'equals' then
        participant.sign_in_count.to_i == self.rule_value.to_i
      when 'greater_than' then
        participant.sign_in_count.to_i > self.rule_value.to_i
      when 'less_than' then
        participant.sign_in_count.to_i < self.rule_value.to_i
      when 'greater_than_or_equal' then
        participant.sign_in_count.to_i >= self.rule_value.to_i
      when 'less_than_or_Equal' then
        participant.sign_in_count.to_i <= self.rule_value.to_i
      else
        false
    end
  end

  ## Check Unused Points Conditions
  def points_check participant
    case self.rule_condition
      when 'equals' then
        participant.points.to_i == self.rule_value.to_i
      when 'greater_than' then
        participant.points.to_i > self.rule_value.to_i
      when 'less_than' then
        participant.points.to_i < self.rule_value.to_i
      when 'greater_than_or_equal' then
        participant.points.to_i >= self.rule_value.to_i
      when 'less_than_or_Equal' then
        participant.points.to_i <= self.rule_value.to_i
      else
        false
    end
  end

  ## Check Participants Recruit Conditions
  def recruits_check participant
    case self.rule_condition
      when 'equals' then
        participant.recruits.to_i == self.rule_value.to_i
      when 'greater_than' then
        participant.recruits.to_i > self.rule_value.to_i
      when 'less_than' then
        participant.recruits.to_i < self.rule_value.to_i
      when 'greater_than_or_equal' then
        participant.recruits.to_i >= self.rule_value.to_i
      when 'less_than_or_Equal' then
        participant.recruits.to_i <= self.rule_value.to_i
      else
        false
    end
  end
end
