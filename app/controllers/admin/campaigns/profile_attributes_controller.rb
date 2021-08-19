class Admin::Campaigns::ProfileAttributesController < Admin::Campaigns::BaseController
  before_action :set_profile_attribute, only: [:edit, :update]

  def index
    @profile_attributes = @campaign.profile_attributes
  end

  def new
    @p_attribute = ProfileAttribute.new
  end

  def create
    @p_attribute = ProfileAttribute.new(profile_attribute_params)
    @p_attribute.is_custom = true

    respond_to do |format|
      if @p_attribute.save
        format.html { redirect_to admin_campaign_profile_attributes_path(@campaign), success: 'Profile Attribute was successfully created.' }
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
        format.html { redirect_to admin_campaign_profile_attributes_path(@campaign), success: 'Profile Attribute was successfully updated.' }
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
    params.require(:profile_attribute).permit(:attribute_name, :display_name, :field_type,
                                            :is_active, :campaign_id)
  end

  def set_profile_attribute
    @p_attribute = @campaign.profile_attributes.where(id: params[:id]).first
  end
end
