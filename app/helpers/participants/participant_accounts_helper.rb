module Participants::ParticipantAccountsHelper

  def get_profile_avatar_url
    url = current_participant.avatar.present? ? current_participant.avatar.banner.url : "end-user/profile_avatar.jpg"
    url
  end

  def get_default_affiliations
    affiliation_types = [
                          {name: 'Alumini', value: 'alumini'},
                          {name: 'Friend', value: 'friend'},
                          {name: 'Student', value: 'student'},
                          {name: 'Faculty/Staff', value: 'falculty_or_staff'},
                          {name: 'Parent/Guardian', value: 'parent_or_guardian'},
                        ]
    affiliation_types
  end

  def get_participant_affiliations
    participant_affiliations = current_participant.participant_profiles.pluck(:value)
    participant_affiliations
  end

end
