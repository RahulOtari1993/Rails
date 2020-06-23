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
    reward = self.reward
    case self.rule_type
      when 'challenges_completed' then
        challenges_completed_check(participant, reward)
      when 'number_of_logins' then
        logins_check(participant, reward)
      when 'points' then
        points_check(participant, reward)
      when 'recruits' then
        recruits_check(participant, reward)
    end
  end

  ## Check Completed Challenges Conditions
  def challenges_completed_check participant, reward
    if reward.date_range
      challenges_completed = participant.submissions
                                 .where(created_at: (reward.start.in_time_zone('UTC'))..(reward.finish.in_time_zone('UTC')))
                                 .count
    else
      challenges_completed = participant.completed_challenges.to_i
    end

    case self.rule_condition
      when 'equals' then
        challenges_completed == self.rule_value.to_i
      when 'greater_than' then
        challenges_completed > self.rule_value.to_i
      when 'less_than' then
        challenges_completed < self.rule_value.to_i
      when 'greater_than_or_equal' then
        challenges_completed >= self.rule_value.to_i
      when 'less_than_or_Equal' then
        challenges_completed <= self.rule_value.to_i
      else
        false
    end
  end

  ## Check Login Conditions
  def logins_check participant, reward
    if reward.date_range
      logins = participant.participant_actions
                   .where(created_at: (reward.start.in_time_zone('UTC'))..(reward.finish.in_time_zone('UTC')))
                   .where(action_type: 'sign_in').count
    else
      logins = participant.sign_in_count.to_i
    end

    case self.rule_condition
      when 'equals' then
        logins == self.rule_value.to_i
      when 'greater_than' then
        logins > self.rule_value.to_i
      when 'less_than' then
        logins < self.rule_value.to_i
      when 'greater_than_or_equal' then
        logins >= self.rule_value.to_i
      when 'less_than_or_Equal' then
        logins <= self.rule_value.to_i
      else
        false
    end
  end

  ## Check Unused Points Conditions
  def points_check participant, reward
    if reward.date_range
      points = participant.participant_actions
                   .where(created_at: (reward.start.in_time_zone('UTC'))..(reward.finish.in_time_zone('UTC')))
                   .sum(:points)
    else
      points = participant.unused_points.to_i
    end

    case self.rule_condition
      when 'equals' then
        points == self.rule_value.to_i
      when 'greater_than' then
        points > self.rule_value.to_i
      when 'less_than' then
        points < self.rule_value.to_i
      when 'greater_than_or_equal' then
        points >= self.rule_value.to_i
      when 'less_than_or_Equal' then
        points <= self.rule_value.to_i
      else
        false
    end
  end

  ## Check Participants Recruit Conditions
  def recruits_check participant, reward
    if reward.date_range
      recruits = participant.participant_actions
                   .where(created_at: (reward.start.in_time_zone('UTC'))..(reward.finish.in_time_zone('UTC')))
                   .where(action_type: 'recruit').count
    else
      recruits = participant.recruits.to_i
    end

    case self.rule_condition
      when 'equals' then
        recruits == self.rule_value.to_i
      when 'greater_than' then
        recruits > self.rule_value.to_i
      when 'less_than' then
        recruits < self.rule_value.to_i
      when 'greater_than_or_equal' then
        recruits >= self.rule_value.to_i
      when 'less_than_or_Equal' then
        recruits <= self.rule_value.to_i
      else
        false
    end
  end
end
