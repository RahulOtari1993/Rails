class WelcomeController < ApplicationController
  skip_before_action :set_organization, :only => :not_found
  before_action :authenticate_participant!, only: [:welcome]
  before_action :authenticate_user!, only: :index, if: -> { @campaign.nil? }
  before_action :set_current_participant, only: :index, if: -> { @campaign.present? }
  append_before_action :setup_default_recruit_challenge

  layout :resolve_layout

  def index
    if @campaign.nil?
      redirect_to admin_organizations_campaigns_path
    else
      if current_participant.present?

        @general_recruit_challenge = @campaign.challenges.referral_default_challenge.first
        @recruit_challenges = @campaign.challenges.referral_social_challenges

        @challenges = @campaign.challenges.current_active.where.not(challenge_type: ['signup', 'connect', 'referral']).select { |x| x.available? }
        @rewards = @campaign.rewards.current_active.select { |x| x.available? }
        claimed_reward_ids = @campaign.participant_actions.where(participant_id: current_participant.id, actionable_type: "Reward").pluck(:actionable_id).uniq
        @claimed_rewards = @campaign.rewards.where(id: claimed_reward_ids)
        render layout: 'end_user_dashboard'
      else
        @challenges = @campaign.challenges.featured.current_active.where.not(challenge_type: ['signup', 'connect'])
        @rewards = @campaign.rewards.featured.current_active
        render layout: 'end_user'
      end
    end
  end

  def home
    if request.referrer.include?('/admin/campaigns/') && request.referrer.last(4).to_s == 'edit'
      @campaign = Campaign.active.where(id: params[:c_id]).first
      @challenges = @campaign.challenges.featured.current_active.where.not(challenge_type: ['signup', 'connect'])
      @rewards = @campaign.rewards.featured.current_active
    end
  end

  ## Render 404 Page
  def not_found
  end

  def welcome
  end

  private

    def resolve_layout
      case action_name
        when 'not_found'
          'not_found'
        else
          'end_user'
      end
    end
end
