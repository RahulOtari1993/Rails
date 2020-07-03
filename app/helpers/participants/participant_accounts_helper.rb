module Participants::ParticipantAccountsHelper

  def get_profile_avatar_url
    url = current_participant.avatar.present? ? current_participant.avatar.banner.url : "end-user/profile_avatar.jpg"
    url
  end

end
