class Admin::Campaigns::RewardsController < ApplicationController
  layout 'campaign_admin'
  before_action :authenticate_user!
  before_action :is_admin
  before_action :set_campaign


  def index
    @rewards = @campaign.rewards
  end

  def new
    @reward = @campaign.rewards.new
  end

  def create
    @reward = @campaign.rewards.new(reward_params)
    if @reward.save 
      redirect_to admin_campaign_rewards_path, notice: 'Reward successfully created'
    else
      render :new, notice: "Error creating rewards"
    end
  end

  private

  def reward_params
    params.require(:reward).permit!
  end
  ## Check Whether Current Logged in User is Org Admin or Not
  def is_admin
    @is_admin = current_user.organization_admin? @organization
  end

  ## Set Campaign
  def set_campaign
    @campaign = Campaign.where(id: params[:campaign_id]).first
  end
end