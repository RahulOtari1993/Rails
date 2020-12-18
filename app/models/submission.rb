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
  after_create :challenge_submission_changes_for_participant

  private

  ## Increase Challenge Submission Counter of Challenge
  def submission_count_change
    challenge = self.challenge
    if challenge.present?
      count = challenge.completions + 1
      challenge.update_attribute(:completions, count)
    end
  end

  ## Challenge Submission Changes for Participant
  def challenge_submission_changes_for_participant
    participant = self.participant
    challenge = self.challenge

    if participant.present? && challenge.present?
      if challenge.challenge_type == 'engage' && (challenge.parameters == 'facebook' || challenge.parameters == 'instagram')
        challenge_points = challenge.post_view_points.to_i
      else
        ## Points Calculations
        if challenge.reward_type == 'points'
          challenge_points = challenge.points.to_i
        elsif challenge.reward_type == 'prize'
          reward = Reward.find(challenge.reward_id)
          challenge_points = reward.points.to_i
        end
      end
      points = participant.points.to_i + challenge_points
      unused_points = participant.unused_points.to_i + challenge_points

      ## Submitted Challenges Counter Changes
      completed_challenges = participant.completed_challenges.to_i + 1

      participant.points = points
      participant.unused_points = unused_points
      participant.completed_challenges = completed_challenges
      participant.save(validate: false)
    end
  end

end
