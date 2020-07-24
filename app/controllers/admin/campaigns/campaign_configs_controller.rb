class Admin::Campaigns::CampaignConfigsController < Admin::Campaigns::BaseController
  def edit
  end

  def update
    respond_to do |format|
      if @config.update(campaign_config_params)
        format.html { redirect_to edit_admin_campaign_config_path(@campaign, @config), notice: 'Program configs were successfully updated.' }
        format.json { render :edit, status: :updated }
      else
        format.html { render :edit }
        format.json { render json: @config.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def campaign_config_params
    params.require(:campaign_config).permit(:facebook_app_id, :facebook_app_secret, :google_client_id,
                                            :google_client_secret, :twitter_app_id, :twitter_app_secret)
  end
end
