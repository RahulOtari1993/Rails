class ReferralCode < ApplicationRecord

  belongs_to :participant
  belongs_to :challenge

  scope :for_challenge, -> (challenge) { where(challenge_id: challenge.id) }

  before_create :generate_code

  def generate_code
    self[:code] = nil
    attempts = 0
    while self[:code].blank? && attempts <= 20 # something is wrong if we hit this one
      code_tmp = SecureRandom.alphanumeric(8)
      if ReferralCode.where(code: code_tmp).empty?
        self[:code] = code_tmp
      end
      attempts += 1
    end
  end
end
