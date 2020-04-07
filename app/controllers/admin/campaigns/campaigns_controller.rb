class Admin::Campaigns::CampaignsController < ApplicationController
  layout 'campaign_admin'

  before_action :authenticate_user!
  before_action :set_campaign
  before_action :is_admin

  def edit
  end

  def update
    respond_to do |format|
      if @campaign.update(campaign_params)
        if @campaign.domain_type == 'sub_domain'
          sub_domain = "#{@organization.sub_domain}.#{@campaign.domain}"
        else
          sub_domain = "#{@organization.sub_domain}#{@campaign.domain}"
        end

        @domain_list = DomainList.where(organization_id: @organization.id, campaign_id: @campaign.id).first

        if @domain_list.update(domain: sub_domain)
          format.html { redirect_to edit_admin_campaign_path(@campaign), notice: 'Campaign was successfully updated.' }
          format.json { render :edit, status: :updated }
        else
          format.html { render :edit }
          format.json { render json: @domain_list.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  ## Check Whether Current Logged in User is Org Admin or Not
  def is_admin
    @is_admin = current_user.organization_admin? @organization
  end

  ## Set Campaign
  def set_campaign
    @campaign = Campaign.where(id: params[:id]).first
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def campaign_params
    params.require(:campaign).permit(:name, :domain, :organization_id, :domain_type, :twitter, :rules,
                                     :privacy, :terms, :contact_us, :faq_title, :faq_content)
  end
end
