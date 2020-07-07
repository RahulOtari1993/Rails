class SocialShareVisit < ApplicationRecord

  belongs_to :shareable, polymorphic: true, optional: true
  belongs_to :participant, optional: true
  belongs_to :referral_code, optional: true

end
