class Admin::Campaigns::BaseController < ApplicationController
  layout 'campaign_admin'

  before_action :authenticate_user!
  before_action :set_details
  before_action :is_admin

  private

  ## Check Whether Current Logged in User is Org Admin or Not
  def is_admin
    @is_admin = current_user.organization_admin? @organization
  end

  ## Set Campaign & Template
  def set_details
    @campaign = Campaign.active.where(id: params[:campaign_id]).first
    if @campaign.present?
      @template = @campaign.campaign_template_detail if @campaign.present?
      @config = @campaign.campaign_config if @campaign.present?
    else
      if params['controller'] == "admin/campaigns/networks" && params['action'] = "instagram_callback" && params['state'].present?
        @campaign = Campaign.active.where(id: params[:campaign_id]).first
        unless
          redirect_to not_found_path
        end
      else
        redirect_to not_found_path
      end
    end
  end

  ## Returns Datatable Page Number
  def datatable_page
    params[:start].to_i / datatable_per_page + 1
  end

  ## Returns Datatable Per Page Length Count
  def datatable_per_page
    params[:length].to_i > 0 ? params[:length].to_i : 10
  end

  ## Returns Datatable Sorting Direction
  def datatable_sort_direction
    params[:order]['0'][:dir] == 'desc' ? 'desc' : 'asc'
  end
end
