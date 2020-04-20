class Admin::Campaigns::ChallengesController < Admin::Campaigns::BaseController
  before_action :build_params, only: :create

  def index
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
  end

  def destroy
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
end
