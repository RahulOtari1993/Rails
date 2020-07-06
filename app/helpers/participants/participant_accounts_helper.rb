module Participants::ParticipantAccountsHelper

  def get_profile_avatar_url
    url = current_participant.avatar.present? ? current_participant.avatar.banner.url : "end-user/profile_avatar.jpg"
    url
  end

  def get_default_affiliations
    affiliation_types = []
    challenge = @campaign.challenges.current_active.where(challenge_type: 'collect', parameters: 'profile').first

    unless challenge.blank?
      question = challenge.questions.where(profile_attribute_id: @campaign.profile_attributes.where(attribute_name: 'affiliation').first.id).first
      affiliation_types = question.question_options.pluck(:details) unless question.blank?
    end

    affiliation_types
  end

  def get_participant_affiliations
    participant_affiliations = current_participant.participant_profiles.pluck(:value)
    participant_affiliations
  end

end
