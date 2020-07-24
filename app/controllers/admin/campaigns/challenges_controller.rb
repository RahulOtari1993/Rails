class Admin::Campaigns::ChallengesController < Admin::Campaigns::BaseController
  before_action :set_challenge, only: [:edit, :update, :show, :participants, :export_participants, :duplicate, :toggle,
                                       :remove_tag, :add_tag]
  before_action :build_segment_params, only: [:create, :update]
  before_action :build_question_params, only: [:create, :update]

  def index
  end

  def fetch_challenges
    challenges = @campaign.challenges
    search_string = []
    filter_query = ''

    ## Check if Search Keyword is Present & Write it's Query
    if params.has_key?('search') && params[:search].has_key?('value') && params[:search][:value].present?
      search_columns.each do |term|
        search_string << "#{term} ILIKE :search"
      end
      challenges = challenges.where(search_string.join(' OR '), search: "%#{params[:search][:value]}%")
    end

    if params["filters"].present?
      filters = JSON.parse(params["filters"].gsub("=>", ":").gsub(":nil,", ":null,"))
      challenges = challenges.challenge_side_bar_filter(filters)
    end

    challenges = challenges.order("#{sort_column} #{datatable_sort_direction}") unless sort_column.nil?
    challenges = challenges.page(datatable_page).per(datatable_per_page)

    render json: {
        challenges: challenges.as_json(type: 'list'),
        draw: params['draw'].to_i,
        recordsTotal: @campaign.challenges.count,
        recordsFiltered: challenges.total_count,
    }
  end

  def new
    @challenge = Challenge.new
  end

  def create
    @challenge = Challenge.new(challenge_params)

    respond_to do |format|
      tags_association ## Manage Tags for a Challenge
      if @challenge.save
        format.html { redirect_to admin_campaign_challenges_path(@campaign), notice: 'Challenge was successfully created.' }
        format.json { render :index, status: :created }
      else
        format.html { render :new }
        format.json { render json: @challenge.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      previous_segments = @challenge.challenge_filters.pluck(:id)
      previous_questions = @challenge.questions.pluck(:id)
      previous_options = QuestionOption.where(question_id: previous_questions).pluck(:id)

      removed_segments = previous_segments - @available_segments
      removed_options = previous_options - @options
      removed_questions = previous_questions - @questions

      tags_association ## Manage Tags for a Challenge

      if @challenge.update(challenge_params)
        ## Remove Deleted User Segments / Questions / Question Options from a Challenge
        @challenge.challenge_filters.where(id: removed_segments).destroy_all if removed_segments.present?
        QuestionOption.where(id: removed_options).delete_all if removed_options.present?
        @challenge.questions.where(id: removed_questions).destroy_all if removed_questions.present?

        format.html { redirect_to admin_campaign_challenges_path(@campaign), notice: 'Challenge was successfully updated.' }
        format.json { render :edit, status: :updated }
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  ## Fetch Challenge Details
  def show
    @participants = Submission.joins(:participant).where(submissions: {challenge_id: @challenge.id})
                        .select("participants.first_name, participants.last_name, participants.email,submissions.created_at")
    @chart_json = []
    @start_date = @challenge.start.strftime('%d %b %Y')
    if @participants.present?
      details = Submission.joins(:participant).where(submissions: {challenge_id: @challenge.id})
                    .select("COUNT(submissions.id) as submission, DATE(submissions.created_at) as creation").group('DATE(submissions.created_at)')

      details.each do |val|
        @chart_json.push([(val.creation.to_datetime.to_i) * 1000, val.submission])
      end
    end
  end

  ## Fetch Participants of Particular Challenge
  def participants
    @participants = @challenge.participants rescue nil
  end

  ## Export Participants of Particular Challenge as a CSV File
  def export_participants
    participants = @challenge.participants
    results = CSV.generate do |csv|
      ## Generate CSV File the Header
      csv << %w(first_name family_name email earned_date)

      ## Add Records in CSV File
      participants.each do |participant|
        csv << [participant.first_name, participant.last_name, participant.email, participant.created_at]
      end
    end

    ## Logic to Download the Generated CSV File
    return send_data results, type: 'text/csv; charset=utf-8; header=present',
                     disposition: 'attachment; filename=challenge_contacts.csv'
  end

  def duplicate
    ## Clone a Challenge With It's Active Record Relation
    cloned = @challenge.deep_clone include: [:challenge_filters, {questions: :question_options}] do |original, copy|
      if copy.is_a?(Challenge)
        ## Clone Challenge Image & Icon
        copy.image = original.image
        copy.icon = original.icon

        ## Clone Challenge Social Image
        copy.social_image = original.social_image
      end
    end

    ## Modify Challenge Details
    cloned.name = "#{@challenge.name} - Duplicate" ## Update Challenge Name
    cloned.is_approved = false ## Make Challenge as Draft
    cloned.approver_id = nil ## Make Approver ID Null

    ## Clone Existing Tags
    cloned.tag_list.add(@challenge.tag_list.join(', '), parse: true) if @challenge.tag_list.present?

    if cloned.save
      render json: {
          success: true,
          title: 'Duplicate a Challenge',
          message: 'Duplicate Challenge created!'
      }
    else
      render json: {
          success: false,
          title: 'Duplicate a Challenge',
          message: 'Duplicating a challenge failed, Pleast try again!'
      }
    end
  end

  ## Approve / Disable a Challenge
  def toggle
    if @challenge.is_approved
      response = toggle_campaign(false)
    else
      if (@challenge.challenge_type == 'signup' || @challenge.challenge_type == 'login')
        config = validate_config

        if config[0]
          response = toggle_campaign(true)
        else
          response = config[1]
        end
      else
        response = toggle_campaign(true)
      end
    end

    render json: response
  end

  ## Remove a Tag From Challenge
  def remove_tag
    @message = ''
    begin
      @challenge.tag_list.remove(params[:tag], parse: true) if params.has_key?('tag') && params[:tag].present?
      @challenge.save!
    rescue StandardError => e
      @message = e.message
    end
  end

  ## Add a Tag to Challenge
  def add_tag
    @message = ''
    begin
      @challenge.tag_list.add(params[:tag].join(', '), parse: true) if params.has_key?('tag') && params[:tag].present?
      @challenge.save!
    rescue StandardError => e
      @message = e.message
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def challenge_params
    return_params = params.require(:challenge).permit(:campaign_id, :name, :link, :description, :reward_type, :timezone,
                                                      :points, :reward_id, :challenge_type, :image, :social_title, :social_description, :use_short_url,
                                                      :start, :finish, :creator_id, :feature, :parameters, :category, :icon,
                                                      :title, :content, :duration, :longitude, :latitude, :address, :caption,
                                                      :location_distance, :social_image, :filter_applied, :filter_type,
                                                      :success_message, :failed_message, :correct_answer_count,
                                                      challenge_filters_attributes: [:id, :challenge_id, :challenge_event,
                                                                                     :challenge_condition, :challenge_value],
                                                      :questions_attributes => [:id, :challenge_id, :category, :title, :is_required, :answer_type,
                                                                                :profile_attribute_id, :placeholder, :additional_details, :sequence,
                                                                                :question_options_attributes => [:id, :question_id, :details, :answer, :sequence, :image]])

    ## Manage End Date, If not present add 500 Years in Start Date and Create a new End Date
    end_date = params[:challenge][:finish].empty? ? generate_end_date : params[:challenge][:finish]

    ## Convert Start & Finish Details in DateTime Object
    return_params[:start] = Chronic.parse(params[:challenge][:start])
    return_params[:finish] = Chronic.parse(end_date)

    ## Manage Reward Type Details
    return_params[:reward_id] = nil if params[:challenge][:reward_type] == 'points' && params[:challenge][:points].present?
    return_params[:points] = nil if params[:challenge][:reward_type] == 'prize' && params[:challenge][:reward_id].present?

    return_params
  end

  ## Build Nested Attributes Params for User Segments
  def build_segment_params
    @available_segments = []
    if params[:challenge].has_key?('challenge_filters_attributes')
      new_params = []

      cust_params = params[:challenge][:challenge_filters_attributes]
      cust_params.each do |key, c_param|
        filter_data = {
            challenge_event: c_param[:challenge_event],
            challenge_condition: c_param[:challenge_condition],
            challenge_value: c_param["challenge_value_#{c_param[:challenge_event]}"]
        }

        if c_param.has_key?('id')
          filter_data[:id] = c_param[:id]
          @available_segments.push(c_param[:id].to_i)
        end

        new_params.push(filter_data)
      end

      params[:challenge][:challenge_filters_attributes] = new_params
    end
  end

  ## Datatable Column List om which search can be performed
  def search_columns
    %w(name challenge_type)
  end

  ## Datatable Column List on which sorting can be performed
  def sort_column
    columns = %w(name challenge_type category start finish)
    columns[params[:order]['0'][:column].to_i - 1]
  end

  def set_challenge
    @challenge = @campaign.challenges.find_by(:id => params[:id]) rescue nil
  end

  ## Assign/Remove Tags to a Challenge
  def tags_association
    tags = params[:challenge][:tags].reject { |c| c.empty? } if params[:challenge].has_key?('tags')
    removed_tags = @challenge.tag_list - tags

    @challenge.tag_list.remove(removed_tags.join(', '), parse: true) if removed_tags.present?
    @challenge.tag_list.add(tags.join(', '), parse: true) if tags.present?
  end

  ## Generate Finish Details in DateTime Object
  def generate_end_date
    existing_date = params[:challenge][:start].split('/')
    date_details = "#{existing_date[1]}/#{existing_date[0]}/#{existing_date[2]}"
    date_obj = DateTime.parse(date_details) + Challenge::END_DATE_YEARS.to_i.years ## Add 500 Years in Start Date and Generate End Date

    date_obj.strftime('%m/%d/%Y %H:%M %p')
  end

  ## Enable / Disable Campaign
  def toggle_campaign(approve_status)
    @challenge.is_approved = approve_status
    @challenge.approver_id = current_user.id

    if @challenge.save
      response = {
          success: true,
          title: "#{@challenge.is_approved ? 'Approve' : 'Disable'} a Challenge",
          message: "Challenge #{@challenge.is_approved ? 'approved' : 'disabled'} successfully!"
      }
    else
      response = {
          success: false,
          title: "#{@challenge.is_approved ? 'Approve' : 'Disable'} a Challenge",
          message: "#{@challenge.is_approved ? 'Approving' : 'Disabling'} challenge failed, Try again later!"
      }
    end

    response
  end

  ## Validate if Social Config Details Are Available for Campaign or Not
  def validate_config
    campaign = @challenge.campaign
    campaign_config = campaign.campaign_config

    is_valid = true

    if @challenge.parameters == 'facebook'
      unless campaign_config.facebook_app_id.present? && campaign_config.facebook_app_secret.present?
        is_valid = false
        message = "Approving challenge failed, Because campaign facebook details are missing."
      end
    elsif @challenge.parameters == 'google'
      unless campaign_config.google_client_id.present? && campaign_config.google_client_secret.present?
        is_valid = false
        message = "Approving challenge failed, Because campaign google details are missing."
      end
    end

    response = {
        success: true,
        title: 'Approve a Challenge',
        message: message
    }

    [is_valid, response]
  end

  ## Build Questions Params
  def build_question_params
    @questions = []
    @options = []

    if params[:challenge].has_key?('questions_attributes')
      new_params = []

      cust_params = params[:challenge][:questions_attributes]
      cust_params.each do |key, c_param|
        option_params = []

        if c_param.has_key?('question_options_attributes')
          c_param[:question_options_attributes].each do |key, option|
            image = option.has_key?('image') ? option[:image] : nil
            option_data = {
                details: option[:details],
                image: image,
                sequence: option[:sequence],
                answer: option.has_key?('answer') ?
                            (c_param[:answer_type] == 'radio_button') ?
                                (option[:answer] == 'on') ? true : nil : option[:answer] : nil
            }
            if option.has_key?('id')
              option_data[:id] = option[:id]
              @options.push(option[:id].to_i)
            end

            option_params.push(option_data)
          end
        end
        answer_type = c_param[:answer_type].split('--')

        filter_data = {
            title: c_param[:title],
            is_required: c_param.has_key?('is_required'),
            category: c_param[:category],
            answer_type: answer_type[0],
            profile_attribute_id: answer_type[1],
            placeholder: c_param[:placeholder],
            additional_details: c_param[:additional_details],
            question_options_attributes: option_params,
            sequence: c_param[:sequence]
        }

        if c_param.has_key?('id')
          filter_data[:id] = c_param[:id]
          @questions.push(c_param[:id].to_i)
        end

        new_params.push(filter_data)
      end

      params[:challenge][:questions_attributes] = new_params
    end
  end
end
