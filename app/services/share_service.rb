class ShareService

  def initialize
    @processed_referral_ids = []
  end

  def process  participant, referral_ids, visit
    @participant = participant
    @referral_ids = referral_ids
    @processed_referral_ids = []

    referral_codes = ReferralCode.where(code: @referral_ids)

    referral_codes.each do |ref_code|
      challenge = ref_code.challenge

      if challenge.challenge_type == 'referral' && !participant.blank? && participant.active?
        # participant signed up so check if referral challenge has already been completed
        process_referral ref_code, participant, challenge, visit
      elsif challenge.challenge_type == 'share'
        # don't need signed up participant to award points for shares
        process_share ref_code, participant, challenge, visit
      else
        # Reward points for other share referrals
      end

      #byebug
    end
    @processed_referral_ids
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
      @referral_code = ReferralCode.create(challenge_id: challenge.id, participant_id: participant.id)
    else
      @referral_code = participant.referral_codes.for_challenge(challenge).first
    end
    base_url = "#{request.protocol}#{request.host}"
    if(challenge.challenge_type == 'share')
      base_url = "#{base_url}/share/#{challenge.id}"
    end
    referral_url = "#{base_url}?refid=#{@referral_code.code}"
    # Currently only  creates a generic (non-platform specific) and facebook
    referral_link = "#{referral_url}&#{challenge.utm_parameters('generic').to_query}"
    facebook_link = "#{referral_url}&#{challenge.utm_parameters.to_query}"
    return { generic: referral_link, facebook: facebook_link}
  end

  def get_shortened_share_urls urls, campaign, participant, request
    # Will need to be refactored to include the campaigns short url domain
    shortened_urls = {}
    urls.each do |platform,url|
      short_url = Shortener::ShortenedUrl.generate(url,owner:participant)

      shortened_urls[platform] = "#{request.protocol}#{request.host}/s/#{short_url.unique_key}"
    end
    shortened_urls
  end

  private

  def process_referral ref_code, participant, challenge, visit
    actions = challenge.participant_actions.where(referred_participant_id: participant.id)

    if actions.empty?
      # Reward the referral points
      action = challenge.participant_actions.create({
        participant_id: ref_code.participant_id,
        points: challenge.points,
        referred_participant_id: participant.id,
        action_type: 'recruit',
        title: 'Recruit Sign Up',
        ip_address: visit.ip,
        campaign_id: challenge.campaign_id,
        ahoy_visit_id: visit.id
      })
      if action.errors.empty?
        challenge.update_attribute(:completions, challenge.completions+1)
        @processed_referral_ids << ref_code.code
      end
    end
  end

  def process_share ref_code, participant, challenge, visit
    actions = challenge.participant_actions.where(ahoy_visit_id: visit.id)

    if actions.empty?
      # Reward the referral points
      action = challenge.participant_actions.create({
        participant_id: ref_code.participant_id,
        points: challenge.points,
        ahoy_visit_id: visit.id,
        action_type: 'share',
        title: 'Visit to share challenge',
        ip_address: visit.ip,
        campaign_id: challenge.campaign_id
      })
      if action.errors.empty?
        challenge.update_attribute(:completions, challenge.completions+1)
        @processed_referral_ids << ref_code.code
      end
    end
  end
end
