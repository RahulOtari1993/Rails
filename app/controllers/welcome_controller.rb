class WelcomeController < ApplicationController
  before_action :authenticate_participant!, only: :welcome
  before_action :authenticate_user!, only: :index, if: -> { @campaign.nil? }
  layout 'end_user'

  def index
    @challenges = @campaign.challenges.featured.current_active
    @rewards = @campaign.rewards.featured.current_active
  end

  def home
    if request.referrer.include?('/admin/campaigns/') && request.referrer.last(4).to_s == 'edit'
      @campaign = Campaign.where(id: params[:c_id]).first
    end
  end

  def welcome
  end

  def participant_dashboard
  end
end
