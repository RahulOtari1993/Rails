class Admin::Campaigns::ChallengesController < Admin::Campaigns::BaseController
  before_action :build_params, only: :create
  before_action :set_challenge, only: [:edit, :update]

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
      if @challenge.update(challenge_params)
        format.html { redirect_to admin_campaign_challenges_path(@campaign), notice: 'Challenge was successfully updated.' }
        format.json { render :edit, status: :updated }
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def challenge_params
    return_params = params.require(:challenge).permit(:campaign_id, :mechanism, :name, :link, :description, :reward_type, :timezone,
                                                      :points, :reward_id, :platform, :image, :social_title, :social_description,
                                                      :start, :finish, challenge_filters_attributes: [:id, :challenge_id, :challenge_event,
                                                                                                      :challenge_condition, :challenge_value])
    ## Convert Start & Finish Details in DateTime Object
    return_params[:start] = Chronic.parse(params[:challenge][:start])
    return_params[:finish] = Chronic.parse(params[:challenge][:finish])

    return_params
  end

  ## Build Nested Attributes Params for User Segments
  def build_params
    if params[:challenge].has_key?('challenge_filters_attributes')
      new_params = []
      cust_params = params[:challenge][:challenge_filters_attributes]
      cust_params.each do |key, c_param|
        new_params.push({
                            challenge_event: c_param[:challenge_event],
                            challenge_condition: c_param[:challenge_condition],
                            challenge_value: c_param["challenge_value_#{c_param[:challenge_event]}"]
                        })
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
