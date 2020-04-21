module ChallengeHelper

  ## Set Active Class to Challenge Mechanism
  def active_challenge_type(type)
    if @challenge.new_record? && type == 'share'
      'active'
    else
      'active' if @challenge.mechanism == type
    end
  end

  ## Set SHOW Class to Challenge Social Blog
  def active_social_blog(type)
    if @challenge.new_record? && type == 'facebook'
      'show'
    else
      'show' if @challenge.platform == type
    end
  end

  ## Set Social Blog Comments
  def social_blog_comment(type)
    if @challenge.new_record? && type == 'facebook'
      "User's comment (must be added by user)"
    else
      @challenge.description
    end
  end

  ## Set Social Blog Title
  def social_blog_title(type)
    if @challenge.new_record?
      default_title(type)
    else
      if @challenge.platform == type
        @challenge.social_title
      else
        default_title(type)
      end
    end
  end

  ## Set Social Blog Description
  def social_blog_description(type)
    if @challenge.new_record?
      default_description(type)
    else
      @challenge.platform == type ? @challenge.social_description : default_description(type)
    end
  end

  ## Set Default Title for Social Blog
  def default_title(type)
    (type == 'facebook' || type == 'linked_in') ? "Welcome to the LIB Experiences Club" : ''
  end

  ## Set Default Description for Social Blog
  def default_description(type)
    details = "We've made it easy for you to win exclusive prizes just by sharing the love about LIB.
      Join today to start earning now. It's easy!"

    details = details + "<span><a href='prk.la/s/h768' class='Social_blocks_twitter_link'>prk.la/s/h768</a></span>" if type == 'twitter'

    details
  end
end
