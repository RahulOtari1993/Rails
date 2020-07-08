module Participants::ChallengesHelper

  def get_challenge_video_id(challenge)
    video_id = VideoInfo.new(challenge.link).video_id
  end
end
