class ChallengeParticipant < ApplicationRecord
  belongs_to :challenge
  belongs_to :participant
end
