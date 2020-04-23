# == Schema Information
#
# Table name: challenge_participants
#
#  id             :bigint           not null, primary key
#  challenge_id   :bigint
#  participant_id :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class ChallengeParticipant < ApplicationRecord
  ## Associations
  belongs_to :challenge
  belongs_to :participant
end
