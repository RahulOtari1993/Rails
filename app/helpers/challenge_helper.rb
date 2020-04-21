module ChallengeHelper

  ## Set Active Class to Challenge Mechanism
  def active_challenge_type(type)
    if @challenge.new_record? && type == 'share'
      'active'
    else
      'active' if @challenge.mechanism == type
    end
  end
end
