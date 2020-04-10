class Admin::Campaigns::RewardsController < ApplicationController
  layout 'campaign_admin'
  before_action :authenticate_user!
  before_action :is_admin
  before_action :set_campaign

  respond_to :html, :json, :js

  def index
    @rewards = @campaign.rewards
  end

  def new
    @reward = @campaign.rewards.new
    @reward_filter = @reward.reward_filters.build
  end

  def create
    byebug
    @reward = @campaign.rewards.new(reward_params)
    if @reward.save 
      redirect_to admin_campaign_rewards_path, notice: 'Reward successfully created'
    else
      render :new, notice: "Error creating rewards"
    end
  end


  def reward_export

    #grab the reward
    @reward = Reward.find(params[:id])

    #generate the csv of the results
    results = CSV.generate do |csv|

      #generate the header
      csv << [
        "first_name",
        "family_name",
        "email",
        "earned_date"
      ]

      #set the results
      @reward.reward_contacts.each do |contact_reward|

        csv << [
          contact_reward.user.first_name,
          contact_reward.user.family_name,
          contact_reward.user.email,
          contact_reward.created_at
        ]
      end
    end

    #send down the results to the user
    return send_data results, type: "text/csv; charset=utf-8; header=present", disposition: "attachment; filename=contacts.csv", filename: "contacts.csv"
  end

  def ajax_user
    @reward = @campaign.rewards.find_by(:id => params[:id])
    # respond_to do |format|
    #   format.html
      # format.js
    # end
  end

  def edit 
    byebug
    @reward = @campaign.rewards.find_by(:id => params[:id])
  end

  def update
    @reward = @campaign.rewards.find_by(:id)
    if @reward.update_attributes(reward_params)
      redirect_to admin_campaign_rewards_path, notice: 'Reward successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @reward = @campaign.rewards.find_by(:id)
    @reward.destroy
    redirect_to :back
  end

  def delete_reward_filter
    @reward = @campaign.reward.find_by(:id=>params[:reward_id])
    @reward_filter = @reward.reward_filters.find_by(:id => params[:id])
    @reward_filter.destroy
    redirect_to edit_campaign_reward_path(@reward), notice: 'Active Segment deleted.'
  end

  private

  def reward_params
    params.require(:reward).permit(:name, :limit, :threshold, :description, :image_file_name, :image_file_size,
                            :image_content_type, :selection, :start, :finish, :feature, :points,
                            :is_active, :redeption_details, :description_details, :terms_conditions,
                            :sweepstake_entry, reward_filters_attributes: [:id, :reward_id, :reward_condition, :reward_value, :reward_event])
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