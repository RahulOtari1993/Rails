class WelcomeController < ApplicationController
  before_action :authenticate_participant!, only: [ :welcome, :participant_dashboard ]
  before_action :authenticate_user!, only: :index, if: -> { @campaign.nil? }
  before_action :set_current_participant, only: :index, if: -> { @campaign.present? }

  layout 'end_user'

  def index
    if @campaign.nil?
      redirect_to admin_organizations_campaigns_path
    else
      if current_participant.present?
        @challenges = @campaign.challenges.current_active #.select {|x| x.available? }
        @rewards = @campaign.rewards.current_active
      else
        @challenges = @campaign.challenges.featured.current_active
        @rewards = @campaign.rewards.featured.current_active
      end
    end
  end

  def home
    if request.referrer.include?('/admin/campaigns/') && request.referrer.last(4).to_s == 'edit'
      @campaign = Campaign.where(id: params[:c_id]).first
    end
  end

  def welcome
  end

  def participant_dashboard
    @challenges = @campaign.challenges.current_active
    @rewards = @campaign.rewards.current_active
  end

  def challenge_details
    @challenge = @campaign.challenges.where(id: params[:id]).first
  end

end
