module Participants::ParticipantAccountsHelper

  def get_profile_avatar_url
    url = current_participant.avatar.present? ? current_participant.avatar.banner.url : "https://graph.facebook.com/105412254539529/picture?type=large"
    url
  end

end
