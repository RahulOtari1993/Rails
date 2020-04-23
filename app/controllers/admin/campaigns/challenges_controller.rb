class Admin::Campaigns::ChallengesController < Admin::Campaigns::BaseController
  before_action :set_challenge, only: [:edit, :update, :show, :participants, :export_participants]
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

    challenges = challenges.order("#{sort_column} #{datatable_sort_direction}") unless sort_column.nil?

    challenges = challenges.page(datatable_page).per(datatable_per_page)

    render json: {
        challenges: challenges.as_json,
        draw: params['draw'].to_i,
        recordsTotal: @campaign.challenges.count,
        recordsFiltered: challenges.total_count
    }
  end

  def new
    @challenge = Challenge.new
  end

  def create
    @challenge = Challenge.new(challenge_params)

    respond_to do |format|
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

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def challenge_params
    return_params = params.require(:challenge).permit(:campaign_id, :mechanism, :name, :link, :description, :reward_type, :timezone,
                                                      :points, :reward_id, :platform, :image, :social_title, :social_description,
                                                      :start, :finish, :creator_id,
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
    if params[:challenge].has_key?('challenge_filters_attributes')
      new_params = []
      @available_segments = []

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
    columns = %w(name platform mechanism start finish)
    columns[params[:order]['0'][:column].to_i - 1]
  end

  def set_challenge
    @challenge = @campaign.challenges.find_by(:id => params[:id]) rescue nil
  end
end
