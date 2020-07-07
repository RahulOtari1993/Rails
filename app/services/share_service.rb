class ShareService

  def initialize

  end

  def run  user, referral_ids
    @user = user
    @referral_ids = referral_ids

  end

  def record_visit refid, visit, participant
    attrs = {
      ahoy_visit_id: visit.id,
      referral_code_str: refid
    }

    referral_code = ReferralCode.where(code: refid).first
    if referral_code
      attrs[:referral_code_id] = referral_code.id
      challenge = referral_code.challenge
      if !challenge.blank?
        attrs[:shareable_id] = challenge.id
        attrs[:shareable_type] = challenge.class.to_s
      end
    end

    if !participant.blank?
      attrs[:participant_id] = participant.id
    end

    social_visit = SocialShareVisit.create(attrs)
    #byebug
    social_visit
  end
end
