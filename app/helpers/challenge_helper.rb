module ChallengeHelper
  ## Check if Object is new record
  def new_record?
    @challenge.new_record?
  end

  ## Set Active Class to Challenge Mechanism
  def active_challenge_type(type)
    if new_record? && type == 'share'
      'active'
    else
      'active' if @challenge.mechanism == type
    end
  end

  ## Set SHOW Class to Challenge Social Blog
  def active_social_blog(type)
    if new_record? && type == 'facebook'
      'show'
    else
      'show' if @challenge.platform == type
    end
  end

  ## Set Social Blog Comments
  def social_blog_comment(type)
    if new_record? && type == 'facebook'
      "User's comment (must be added by user)"
    else
      @challenge.description
    end
  end

  ## Set Social Blog Title
  def social_blog_title(type, input_type)
    if new_record?
      default_title(type, input_type)
    else
      if @challenge.platform == type
        @challenge.social_title
      else
        default_title(type, input_type)
      end
    end
  end

  ## Set Social Blog Description
  def social_blog_description(type, input_type)
    if new_record?
      default_description(type, input_type)
    else
      @challenge.platform == type ? @challenge.social_description : default_description(type, input_type)
    end
  end

  ## Set Default Title for Social Blog
  def default_title(type, input_type)
    if input_type == 'input'
      return nil;
    else
      return (type == 'facebook' || type == 'linked_in') ? "Welcome to the LIB Experiences Club" : ''
    end
  end

  ## Set Default Description for Social Blog
  def default_description(type, input_type)
    if input_type == 'input'
      return nil;
    else
      details = "We've made it easy for you to win exclusive prizes just by sharing the love about LIB.
      Join today to start earning now. It's easy!"

      details = details + "<span><a href='prk.la/s/h768' class='Social_blocks_twitter_link'>prk.la/s/h768</a></span>" if type == 'twitter'

      return details
    end
  end

  ## Set Social Blog Title
  def social_blog_image(type)
    if new_record?
      "<img src='#' id='show-#{type}-image'>"
    else
      if @challenge.platform == type
        "<img src='#{@challenge.image.url}' id='show-#{type}-image'>"
      else
        "<img src='#' id='show-#{type}-image'>"
      end
    end
  end

  ## Check Whether to Validate Social Image of Not
  def validate_social_image(type)
    if new_record?
      'always-validate'
    else
      @challenge.platform != type ? 'always-validate' : ''
    end
  end

  ## Set Social Blog Link
  def social_blog_link(type)
    if new_record?
      'LIB.PERKSOCIAL.COM'
    else
      if @challenge.platform == type
        @challenge.link
      else
        'LIB.PERKSOCIAL.COM'
      end
    end
  end

  ## Set Reward Type Active Pill
  def active_reward_pill(type)
    if new_record? && type == 'points'
      'active'
    else
      @challenge.reward_type == type ? 'active' : ''
    end
  end

  ## Set Challenge Start Date
  def start_date
    new_record? ? '' : @challenge.start.strftime('%m/%d/%Y')
  end

  ## Set Challenge Start Time
  def start_time
    new_record? ? '' : @challenge.start.strftime('%I:%M %p')
  end

  ## Set Challenge Finish Date
  def finish_date
    if new_record?
      ''
    else
      @challenge.finish.present? ? @challenge.finish.strftime('%m/%d/%Y') : ''
    end
  end

  ## Set Challenge Finish Time
  def finish_time
    if new_record?
      ''
    else
      @challenge.finish.present? ? @challenge.finish.strftime('%I:%M %p') : ''
    end
  end

  ## Set Reward Type Active Pill Tab
  def active_reward_pill_tab(type)
    if new_record? && type == 'points'
      'active'
    else
      @challenge.reward_type == type ? 'active' : 'pill-btn'
    end
  end

  ## Set Name Convention String for User Segment
  def name_convention(filter = nil)
    filter.present? ? filter.id : '___NUM___'
  end

  ## Set ID Convention String for User Segment
  def id_convention(filter = nil)
    filter.present? ? filter.id : '___ID___'
  end

  ## User Segment Set Default Value of Event's User Segment Type
  def challenge_event_value(filter, value)
    if filter.present?
      filter.challenge_event
    else
      value
    end
  end

  ## User Segment Set Default Value of Event Condition
  def condition_value(filter, value)
    if filter.present?
      filter.challenge_condition
    else
      value
    end
  end

  ## User Segment Set Default Value of Event Value
  def event_value(filter, value, type)
    if filter.present?
      filter.challenge_event == type ? filter.challenge_value : value
    else
      value
    end
  end

  ## User Segment Set DISABLED Fields
  def make_disabled(filter, type)
    if filter.present?
      !type.include?(filter.challenge_event)
    else
      !type.include?('age')
    end
  end
end
