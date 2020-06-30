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
      "<img id='challenge-image-preview' src='#{@challenge.image.url(:banner)}'/>"
    end
  end

  ## Icon Image Load While Editing a Challenge
  def challenge_image_icon_load
    if @challenge.new_record?
      "<img id='challenge-icon-image-preview' />"
    else
      "<img id='challenge-icon-image-preview' src='#{@challenge.icon.url}'/>"
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

  ## Set Name Convention String for Question
  def q_name_convention(template = false, question = nil, identifier = nil)
    if template
      question.present? ? question.id : '___NUM___'
    else
      identifier.present? ? identifier : '12Q21'
    end
  end

  ## Question Set Default Value of Question Title
  def question_value(question = nil)
      if question.present?
        question.title
      else
        'Untitled Question'
      end
  end

  ## Question Set Default Value of Question Placeholder
  def placeholder_value(question = nil)
    if question.present?
      question.placeholder
    else
      ''
    end
  end

  ## Question Set Default Value of Question Additional Details
  def additional_details_value(question = nil)
    if question.present?
      question.additional_details
    else
      ''
    end
  end

  ## Question Set Default Value of Question Option
  def option_value(option = nil, counter = 1)
    if option.present?
      option.details
    else
      "Option #{counter}"
    end
  end

  ## Set ID Convention String for Question
  def o_id_convention(template = nil, option = nil, id_details)
    if template
      option.present? ? option.id : '___O_ID___'
    else
      id_details
    end
  end

  ## Set Question Field Type
  def select_question_field_type(question = nil, index = 0, profileId = 0)
    selection = ''
    if question.present?
      selection = question.profile_attribute_id == profileId ? 'selected' : ''
    else
      selection = index == 0 ? 'selected' : ''
    end

    selection
  end

  ## Set Whether Question is Required or Not
  def question_required(question = nil)
    if question.present?
      question.is_required
    else
      false
    end
  end

  ## Check Whether Answer or Not
  def option_is_answer(option = nil, default = false)
    if option.present?
      option.answer.present? ? true : false
    else
      default ? true : false
    end
  end

  ## Quiz Short Answer Value
  def quiz_short_answer(question)
    if question.present? && question.question_options.present?
      question.question_options.first.answer
    else
      ''
    end
  end

  ## Display Relevant Question Options & Hide Others
  def display_question_option(question = nil, type = 'string')
    if question.present?
      question.answer_type == type ? '' : 'hide-options'
    else
      type == 'string' ? '' : 'hide-options'
    end
  end

  ## Create Option Identifire
  def option_identifire(template = nil, option = nil, identifire = 1, count = 1)
    if template
      option.present? ? option.id : "___O_IDENTIFIRE_#{count}___"
    else
      identifire
    end
  end

  ## Create Short Answer Name
  def quiz_short_answer_name(template = nil, question = nil, identifire = 1, count = 1)
    if template
      if question.present? && question.question_options.present?
        question.question_options.first.id
      else
        "___O_IDENTIFIRE_#{count}___"
      end
    else
      identifire
    end
  end

  ## Get wysiwyg content of a Question
  def wysiwyg_content(question = nil)
    if question.present? && question.question_options.present?
      question.question_options.first.details
    else
      ''
    end
  end

  ## Return Actual Question Count
  def correct_answer_count
    if @challenge.new_record?
      [[1, 1]]
    else
      response = []
      counts = @challenge.questions.where.not(answer_type: 'wysiwyg').count
      counts.times.each do |cnt|
        response.push([cnt + 1, cnt + 1])
      end

      response
    end
  end

  ## Fetch Unused Instant Rewards of a Campaign
  def challenge_reward_list
    used_reward_ids = @campaign.challenges.all.pluck(:reward_id).compact
    used_reward_ids = used_reward_ids - [@challenge.reward_id] if @challenge.reward_id.present?
    @campaign.rewards.active.where(selection: 'instant').where.not(id: used_reward_ids).map { |v| [v.name.titleize, v.id] }.compact
  end

  ## User Segment List for Challenges
  def challenge_user_segment_list
    filter_list = []
    ChallengeFilter::EVENTS.each do |filter_type|
      if filter_type == 'age' || filter_type == 'tags' || filter_type == 'gender'
        filter_list.push([filter_type.titleize, filter_type])
      elsif filter_type == 'current-points'
        filter_list.push(['Current Points', filter_type])
      elsif filter_type == 'lifetime-points'
        filter_list.push(['Lifetime Points', filter_type])
      elsif filter_type == 'challenge'
        filter_list.push(['Challenges Completed', filter_type])
      elsif filter_type == 'login'
        filter_list.push(['User Logins', filter_type])
      end
    end

    filter_list
  end

  ## Set Question Sequence
  def q_name_convention(template = false, question = nil, identifier = nil)
    if template
      question.present? ? question.id : '___NUM___'
    else
      identifier.present? ? identifier : '12Q21'
    end
  end
end
