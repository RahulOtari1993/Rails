class Admin::Campaigns::ProfileAttributesController < Admin::Campaigns::BaseController

  def index
    @profile_attributes = @campaign.profile_attributes
  end

  def new
    @p_attribute = ProfileAttribute.new
  end

  def create
    @p_attribute = ProfileAttribute.new(profile_attribute_params)

    respond_to do |format|
      if @p_attribute.save
        format.html { redirect_to admin_campaign_profile_attributes_path(@campaign, @p_attribute), notice: 'Profile Attribute was successfully created.' }
        format.json { render :index, status: :created }
      else
        format.html { render :new }
        format.json { render json: @p_attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @p_attribute.update(profile_attribute_params)
        format.html { redirect_to admin_campaign_profile_attributes_path(@campaign, @p_attribute), notice: 'Profile Attribute was successfully updated.' }
        format.json { render :edit, status: :updated }
      else
        format.html { render :edit }
        format.json { render json: @p_attribute.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def profile_attribute_params
    params.require(:profile_attribute).permit(:facebook_app_id, :facebook_app_secret, :google_client_id,
                                            :google_client_secret, :twitter_app_id, :twitter_app_secret)
  end
end
