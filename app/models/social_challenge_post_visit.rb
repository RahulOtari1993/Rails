class SocialChallengePostVisit < ApplicationRecord
  belongs_to :challenge
  belongs_to :participant
end
