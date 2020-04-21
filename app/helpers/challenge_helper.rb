module ChallengeHelper

  ## Set Active Class to Challenge Mechanism
  def active_challenge_type(type)
    if @challenge.new_record? && type == 'share'
      'active'
    else
      'active' if @challenge.mechanism == type
    end
  end

  ## Set SHOW Class to Challenge Social Blogs
  def active_social_blog(type)
    if @challenge.new_record? && type == 'facebook'
      'show'
    else
      'show' if @challenge.platform == type
    end
  end
end
