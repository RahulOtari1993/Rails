class Admin::Campaigns::ChallengesController < Admin::Campaigns::BaseController
  before_action :set_challenge, only: [:edit, :update, :show, :participants, :export_participants, :duplicate, :toggle]
  before_action :build_params, only: [:create, :update]

  def index
  end

  def fetch_challenges
    challenges = @campaign.challenges

    ## Check if Search Keyword is Present & Write it's Query
    if params.has_key?('search') && params[:search].has_key?('value') && params[:search][:value].present?
      search_string = []
      search_columns.each do |term|
        search_string << "#{term} ILIKE :search"
      end
      challenges = challenges.where(search_string.join(' OR '), search: "%#{params[:search][:value]}%")
    end

    if params["draft"] == "true"
      challenges = challenges.where(:is_approved => false)
    elsif params["active"] == "true"
      challenges = challenges.where(:is_approved => true)
    elsif params["scheduled"] == "true"
      challenges = challenges.where(:is_approved => true)
      scheduled_challenges = challenges.select{|challenge| challenge.start.in_time_zone(challenge.timezone) > Time.now.in_time_zone(challenge.timezone)}
      challenges = challenges.where(:id => scheduled_challenges.pluck(:id))
    elsif params["ended"] == "true"
      ended_challenges = challenges.select{|challenge| challenge.finish.in_time_zone(challenge.timezone) < Time.now.in_time_zone(challenge.timezone)}
      challenges = challenges.where(:id => ended_challenges.pluck(:id))
    elsif params["share"] == "true"
      challenges = challenges.where(:challenge_type => 'share')
    elsif params["connect"] == "true"
      challenges = challenges.where(:challenge_type => 'connect')
    elsif params["engage"] == "true"
      challenges = challenges.where(:challenge_type => 'engage')
    elsif params["collect"] == "true"
      challenges = challenges.where(:challenge_type => 'collect')
    elsif params["facebook"] == "true"
      challenges = challenges.where(:parameters => 'facebook')
    elsif params["instagram"] == "true"
      challenges = challenges.where(:parameters => 'instagram')
    elsif params["tumblr"] == "true"
      challenges = challenges.where(:parameters => 'tumblr')
    elsif params["twitter"] == "true"
      challenges = challenges.where(:parameters => 'twitter')
    elsif params["youtube"] == "true"
      challenges = challenges.where(:parameters => 'youtube')
    elsif params["points"] == "true"
      challenges = challenges.where(:reward_type => 'points')
    elsif params["prizes"] == "true"
      challenges = challenges.where(:reward_type => 'prizes')
    else
    end

    challenges = challenges.order("#{sort_column} #{datatable_sort_direction}") unless sort_column.nil? 
    challenges = challenges.page(datatable_page).per(datatable_per_page)

    render json: {
      challenges: challenges.as_json,
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

      removed_segments = previous_segments - @available_segments
      tags_association ## Manage Tags for a Challenge

      if @challenge.update(challenge_params)
        ## Remove Deleted User Segments from a Challenge
        @challenge.challenge_filters.where(id: removed_segments).delete_all if removed_segments.present?

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
    cloned = @challenge.deep_clone include: :challenge_filters do |original, copy|
      if copy.is_a?(Challenge)
        ## Clone Challenge Image
        copy.image = original.image
      end
    end

    ## Modify Challenge Details
    cloned.name = "#{@challenge.name} - Duplicate" ## Update Challenge Name
    cloned.is_approved = false ## Make Challenge as Draft
    cloned.approver_id = nil ## Make Approver ID Null

    ## Clone Existing Tags
    cloned.tag_list.add(@challenge.tag_list.join(', '), parse: true) if @challenge.tag_list.present?

    if cloned.save
      render json: {success: true}
    else
      render json: {success: false}
    end
  end

  ## Approve / Disable a Challenge
  def toggle
    @challenge.is_approved = @challenge.is_approved ? false : true
    @challenge.approver_id = current_user.id

    if @challenge.save
      render json: {
          success: true,
          title: "#{@challenge.is_approved ? 'Approve' : 'Disable'} a Challenge",
          message: "Challenge #{@challenge.is_approved ? 'approved' : 'disabled'} successfully!"
      }
    else
      render json: {
          success: false,
          title: "#{@challenge.is_approved ? 'Approve' : 'Disable'} a Challenge",
          message: "#{@challenge.is_approved ? 'Approving' : 'Disabling'} challenge failed, Try again later!"
      }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def challenge_params
    return_params = params.require(:challenge).permit(:campaign_id, :mechanism, :name, :link, :description, :reward_type, :timezone,
                                                      :points, :reward_id, :challenge_type, :image, :social_title, :social_description,
                                                      :start, :finish, :creator_id, :feature, :parameters, :category,
                                                      :title, :content, :duration, :longitude, :latitude, :address,
                                                      :location_distance, :tags,
                                                      challenge_filters_attributes: [:id, :challenge_id, :challenge_event,
                                                                                     :challenge_condition, :challenge_value])
    ## Convert Start & Finish Details in DateTime Object
    return_params[:start] = Chronic.parse(params[:challenge][:start])
    return_params[:finish] = Chronic.parse(params[:challenge][:finish])

    ## Manage Reward Type Details
    return_params[:reward_id] = nil if params[:challenge][:reward_type] == 'points' && params[:challenge][:points].present?
    return_params[:points] = nil if params[:challenge][:reward_type] == 'prize' && params[:challenge][:reward_id].present?

    return_params
  end

  ## Build Nested Attributes Params for User Segments
  def build_params
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
    %w(name mechanism)
  end

  ## Datatable Column List on which sorting can be performed
  def sort_column
    columns = %w(name challenge_type mechanism start finish)
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
end
