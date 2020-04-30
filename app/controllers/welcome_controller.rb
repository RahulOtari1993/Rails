class WelcomeController < ApplicationController
  before_action :authenticate_participant!, only: :participants
  layout 'end_user'

  def index
  end

  def home
    if request.referrer.include?('/admin/campaigns/') && request.referrer.last(4).to_s == 'edit'
      @campaign = Campaign.where(id: params[:c_id]).first
    end
  end

  def participants
  end
end
