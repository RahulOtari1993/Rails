class ShareService

  def initialize

  end

  def run  participant, referral_ids, visit
    @participant = participant
    @referral_ids = referral_ids
    processed_referral_ids = []

    referral_codes = ReferralCode.where(code: @referral_ids)
    referral_codes.each do |ref_code|
      challenge = ref_code.challenge

      if challenge.challenge_type == 'referral' and !participant.blank?
        # participant signed up so check if referral challenge has already been completed
        actions = challenge.participant_actions.where(referred_participant_id: participant.id)

        if actions.empty?
          # Reward the referral points
          action = challenge.participant_actions.create({
            participant_id: ref_code.participant_id,
            points: challenge.points,
            referred_participant_id: participant.id,
            action_type: 'recruit',
            title: 'Recruit Sign Up',
            ip_address: visit.ip
          })
          processed_referral_ids << ref_code.code
        end
      else
        # Reward points for other share referrals
      end
    end
    processed_referral_ids
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

  def get_share_urls challenge, participant, request
    if participant.referral_codes.for_challenge(challenge).empty?
      referral_code = ReferralCode.create(challenge_id: challenge.id, participant_id: participant.id)
    else
      @referral_code = participant.referral_codes.for_challenge(challenge).first
    end

    # Currently only  creates a generic (non-platform specific) and facebook
    @referral_link = "#{request.protocol}#{request.host}?refid=#{@referral_code.code}&#{challenge.utm_parameters('generic').to_query}"
    @facebook_link = "#{@referral_link}&#{challenge.utm_parameters('facebook').to_query}"
    return { generic: @referral_link, facebook: @facebook_link}
  end

  def get_shortened_share_urls urls

  end
end
