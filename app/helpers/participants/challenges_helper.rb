module Participants::ChallengesHelper

  def get_challenge_video_id(challenge)
    video_id = VideoInfo.new(challenge.link).video_id
  end

  def is_question_required(question)
    result = question.is_required ? 'question_required' :  false
    result
  end
end
