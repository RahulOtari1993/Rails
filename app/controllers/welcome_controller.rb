class WelcomeController < ApplicationController
  before_action :authenticate_participant!, only: [ :welcome ]
  before_action :authenticate_user!, only: :index, if: -> { @campaign.nil? }
  before_action :set_current_participant, only: :index, if: -> { @campaign.present? }

  layout 'end_user'

  def index
    binding.pry
    if @campaign.nil?
      redirect_to admin_organizations_campaigns_path
    else
      if current_participant.present?
        @challenges = @campaign.challenges.current_active.where.not(challenge_type: ['signup', 'connect']).select {|x| x.available? }
        @rewards = @campaign.rewards.current_active.select {|x| x.available? }
      else
        @challenges = @campaign.challenges.featured.current_active.where.not(challenge_type: ['signup', 'connect'])
        @rewards = @campaign.rewards.featured.current_active
      end
    end
  end

  def home
    if request.referrer.include?('/admin/campaigns/') && request.referrer.last(4).to_s == 'edit'
      @campaign = Campaign.where(id: params[:c_id]).first
      @challenges = @campaign.challenges.featured.current_active.where.not(challenge_type: ['signup', 'connect'])
      @rewards = @campaign.rewards.featured.current_active
    end
  end

  def welcome
  end

end
