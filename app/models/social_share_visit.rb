class SocialShareVisit < ApplicationRecord

  belongs_to :shareable, polymorphic: true, optional: true
  belongs_to :participant, optional: true
  belongs_to :referral_code, optional: true

  #validates :referral_code, uniqueness: { scope: [:participant_id] }, if: -> { !participant_id.blank? }

end
