module ChallengeHelper
  ## Check if Object is new record
  def new_record?
    @challenge.new_record?
  end

  # ## Set Active Class to Challenge Mechanism
  def active_challenge_type(type, parameters)
    if new_record? && type == 'share' && parameters == 'facebook'
      'active'
    else
      'active' if @challenge.challenge_type == type && @challenge.parameters == parameters
    end
  end

  ## Set SHOW Class to Challenge Social Blog
  def active_social_blog(type)
    if new_record? && type == 'facebook'
      'show'
    else
      'show' if @challenge.parameters == type
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
      if @challenge.parameters == type
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
      @challenge.parameters == type ? @challenge.social_description : default_description(type, input_type)
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
      if @challenge.parameters == type
        "<img src='#{@challenge.social_image.url}' id='show-#{type}-image'>"
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
      @challenge.parameters != type ? 'always-validate' : ''
    end
  end

  ## Set Social Blog Link
  def social_blog_link(type)
    if new_record?
      'LIB.PERKSOCIAL.COM'
    else
      if @challenge.parameters == type
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

  ## User Segment Set VISIBLE Fields
  def make_visible(filter, type)
    if filter.present?
      type.include?(filter.challenge_event) ? 'block' : 'none'
    else
      type.include?('age') ? 'block' : 'none'
    end
  end

  ## Image Load While Editing a Challenge
  def challenge_image_load
    if @challenge.new_record?
      "<img id='challenge-image-preview' />"
    else
      "<img id='challenge-image-preview' src='#{@challenge.image.url}'/>"
    end
  end

  ## Dynamically Pick Tags UI Class
  def tags_class
    ['chip-success', 'chip-warning', 'chip-danger', 'chip-primary'].sample
  end

  ## Return Challenge User Segment Filter Type Options
  def filter_type
    Challenge::filter_types.map{|k,v| [k == 'all_filters' ? 'All' : 'Any', k]}
  end

  ## Show Hide User Segment
  def display_user_segments
    @challenge.filter_applied ? 'block' : 'none'
  end

  ## Challenge Status Indicator
  def challenge_status_indicator
    status = @challenge.status
    if status == 'draft'
      class_name = 'fa fa-circle-o fa_draft fa_circle_lg'
    elsif status == 'scheduled'
      class_name = 'fa fa-circle-o fa_scheduled fa_circle_lg'
    elsif status == 'active'
      class_name = 'fa fa-circle fa_active fa_circle_lg'
    else
      class_name = 'fa fa-circle fa_ended fa_circle_lg'
    end
  end

  ## Question ID Builder
  def question_build_id(needChange, type, string)
    customString = string

    if needChange
      if type == 'class'
        customString = customString + '-___CLASS___'
      end
    end

    customString
  end
end
