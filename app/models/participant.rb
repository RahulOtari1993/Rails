# == Schema Information
#
# Table name: participants
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  first_name             :string
#  last_name              :string
#  is_active              :boolean          default(FALSE), not null
#  is_deleted             :boolean          default(FALSE), not null
#  deleted_by             :integer
#  organization_id        :integer
#  campaign_id            :integer
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  utm_source             :string
#  utm_medium             :string
#  utm_term               :string
#  utm_content            :string
#  utm_name               :string
#  birth_date             :date
#  gender                 :string
#  phone                  :string
#  city                   :string
#  state                  :string
#  postal                 :string
#  address_1              :string
#  address_2              :string
#  bio                    :text
#  p_id                   :string
#  facebook_uid           :string
#  facebook_token         :string
#  facebook_expires_at    :datetime
#  google_uid             :string
#  google_token           :string
#  google_refresh_token   :string
#  google_expires_at      :datetime
#  points                 :integer          default(0)
#  unused_points          :integer          default(0)
#  clicks                 :integer          default(0)
#  likes                  :integer          default(0)
#  comments               :integer          default(0)
#  reshares               :integer          default(0)
#  recruits               :integer          default(0)
#  connect_type           :integer
#  age                    :integer          default(0)
#  completed_challenges   :integer          default(0)
#
class Participant < ApplicationRecord
  ## Devise Configurations
  devise :database_authenticatable, :registerable, :confirmable, :trackable,
         :recoverable, :rememberable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2],
         :authentication_keys => [:email, :organization_id, :campaign_id],
         :reset_password_keys => [:email, :organization_id, :campaign_id]

  ## Associations
  belongs_to :organization
  belongs_to :campaign
  has_many :challenge_participants, dependent: :destroy
  has_many :challenges, through: :challenge_participants
  has_many :submissions, dependent: :destroy
  has_many :participant_actions, dependent: :destroy
  has_many :participant_profiles, dependent: :destroy

  has_many :reward_participants, dependent: :destroy
  has_many :rewards, through: :reward_participants
  has_many :coupons, through: :reward_participants

  ## Callbacks
  after_create :generate_participant_id
  after_save :check_milestone_reward

  ## ENUM
  enum connect_type: {facebook: 0, google: 1, email: 3}

  ## Nested Attributes
  accepts_nested_attributes_for :participant_profiles, allow_destroy: true, :reject_if => :all_blank

  ## Tags
  acts_as_taggable_on :tags

  ## Get Current Participant
  def self.current
    Thread.current[:participant]
  end

  ## Set Current Participant
  def self.current=(participant)
    Thread.current[:participant] = participant
  end

  ## Password Validation Condition
  PASSWORD_VALIDATOR = /(          # Start of group
        (?:                        # Start of nonmatching group, 4 possible solutions
          (?=.*[a-z])              # Must contain one lowercase character
          (?=.*[A-Z])              # Must contain one uppercase character
          (?=.*\W)                 # Must contain one non-word character or symbol
        |                          # or...
          (?=.*\d)                 # Must contain one digit from 0-9
          (?=.*[A-Z])              # Must contain one uppercase character
          (?=.*\W)                 # Must contain one non-word character or symbol
        |                          # or...
          (?=.*\d)                 # Must contain one digit from 0-9
          (?=.*[a-z])              # Must contain one lowercase character
          (?=.*\W)                 # Must contain one non-word character or symbol
        |                          # or...
          (?=.*\d)                 # Must contain one digit from 0-9
          (?=.*[a-z])              # Must contain one lowercase character
          (?=.*[A-Z])              # Must contain one uppercase character
        )                          # End of nonmatching group with possible solutions
        .*                         # Match anything with previous condition checking
      )/x # End of group

  # Validations
  validates :first_name, presence: true
  validates :email, confirmation: true

  # From Devise module Validatable
  validates_presence_of :email, if: :email_required?

  validates_uniqueness_of :email,
                          scope: [:organization_id, :campaign_id],
                          message: "already exists for this campaign"

  validates_format_of :email,
                      with: /\A[^@]+@[^@]+\z/,
                      allow_blank: true,
                      if: :email_changed?

  ## Password Validations
  # validates_presence_of :password
  validates :password, presence: true, if: Proc.new { |participant| participant.password.present? }, confirmation: true, on: :update
  validates_confirmation_of :password, if: :confirmation_password_required?
  validates_length_of :password, within: 8..20, allow_blank: true
  validate :password_complexity

  def password_complexity
    return if password.blank? || password =~ PASSWORD_VALIDATOR

    errors.add :password,
               'Complexity requirement not met. Must contain 3 of the following 4: <BR />1) A lowercase letter,
                <BR />2) An uppercase letter, <BR />3) A digit, <BR />4) A non-word character or symbol'
  end

  def confirmation_password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  # From Devise module Validatable
  def email_required?
    true
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  ## Facebook OmniAuth
  def self.facebook_omniauth(auth, params, user_agent = '', remote_ip = '')
    org = Organization.where(id: params['oi']).first rescue nil
    camp = org.campaigns.where(id: params['ci']).first rescue nil if org.present?
    participant = Participant.where(organization_id: org.id, campaign_id: camp.id, facebook_uid: auth['uid']).first
    unless participant.present?
      participant = Participant.where(organization_id: org.id, campaign_id: camp.id, email: auth.info.email).first
    end

    if participant.present?
      participant.facebook_uid = auth.uid
      participant.facebook_token = auth.credentials.token
      participant.facebook_expires_at = Time.at(auth.credentials.expires_at)
      participant.connect_type = 'facebook'
    else
      name = auth.info.name.split(" ")

      params = {
          organization_id: org.id,
          campaign_id: camp.id,
          facebook_uid: auth.uid,
          email: auth.info.email,
          password: Devise.friendly_token[0, 20],
          is_active: true,
          first_name: name[0],
          last_name: name[1],
          facebook_token: auth.credentials.token,
          facebook_expires_at: Time.at(auth.credentials.expires_at),
          confirmed_at: DateTime.now,
          connect_type: 'facebook'
      }

      participant = Participant.new(params)
      participant.skip_confirmation!
    end

    if participant.save(:validate => false)
      participant.connect_challenge_completed(user_agent, remote_ip)
      participant
    else
      Participant.new
    end
  end

  ## Google OmniAuth
  def self.google_omniauth(auth, params, user_agent = '', remote_ip = '')
    org = Organization.where(id: params['oi']).first rescue nil
    camp = org.campaigns.where(id: params['ci']).first rescue nil if org.present?

    participant = Participant.where(organization_id: org.id, campaign_id: camp.id, google_uid: auth['uid']).first
    unless participant.present?
      participant = Participant.where(organization_id: org.id, campaign_id: camp.id, email: auth.info.email).first
    end
    refresh_token = auth.credentials.refresh_token.present?

    if participant.present?
      participant.google_uid = auth.uid
      participant.google_token = auth.credentials.token
      participant.google_refresh_token = auth.credentials.refresh_token if refresh_token
      participant.google_expires_at = Time.at(auth.credentials.expires_at)
      participant.connect_type = 'google'
    else
      params = {
          organization_id: org.id,
          campaign_id: camp.id,
          google_uid: auth.uid,
          email: auth.info.email,
          password: Devise.friendly_token[0, 20],
          is_active: true,
          first_name: auth.info.first_name,
          last_name: auth.info.last_name,
          google_token: auth.credentials.token,
          google_refresh_token: auth.credentials.refresh_token,
          google_expires_at: Time.at(auth.credentials.expires_at),
          confirmed_at: DateTime.now,
          connect_type: 'google'
      }

      participant = Participant.new(params)
      participant.skip_confirmation!
    end

    if participant.save(:validate => false)
      participant.connect_challenge_completed(user_agent, remote_ip)
      participant
    else
      Participant.new
    end
  end

  def self.get_participant_id
    new_id = SecureRandom.hex (6)
    p_id = self.where(p_id: new_id.upcase)
    if p_id.present?
      self.get_participant_id
    else
      new_id.upcase
    end
  end

  ## Check If Participant Completed SignUp Challenge & Assign Point
  def connect_challenge_completed(user_agent = '', remote_ip = '')
    ## Fetch the Campaign
    campaign = Campaign.where(id: self.campaign_id).first
    if campaign.present?
      ## Fetch the Challenge (Facebook, Google, Email)
      challenge = campaign.challenges.current_active.where(challenge_type: 'signup', parameters: self.connect_type).first
      if challenge.present?
        ## Create Participant Action Log
        action_item = ParticipantAction.new({participant_id: self.id, points: 0,
                                             action_type: 'sign_up', title: 'Signed up',
                                             user_agent: user_agent, ip_address: remote_ip})
        action_item.save

        ## Check if the Challenge is Submitted Previously
        is_submitted = Submission.where(campaign_id: campaign.id, participant_id: self.id, challenge_id: challenge.id).present?

        unless is_submitted
          ## Submit Challenge
          submit = Submission.new({campaign_id: campaign.id, participant_id: self.id, challenge_id: challenge.id,
                                   user_agent: user_agent, ip_address: remote_ip})
          submit.save

          ## Create Participant Action Log
          sign_up_log = ParticipantAction.new({participant_id: self.id, points: challenge.points.to_i,
                                               action_type: 'sign_up', title: 'Signed up', actionable_id: challenge.id,
                                               actionable_type: 'Challenge', details: challenge.caption,
                                               user_agent: user_agent, ip_address: remote_ip})
          sign_up_log.save
        end
      end
    end

  end

  private

  ## Generate Uniq Participant ID
  def generate_participant_id
    self.update_attribute('p_id', Participant.get_participant_id)
  end

  ## Check If User is Eligible for Milestone Reward
  def check_milestone_reward
    if saved_change_to_unused_points? || saved_change_to_completed_challenges? || saved_change_to_sign_in_count? || saved_change_to_recruits?
      reward_check = RewardsService.new(self.id)
      reward_check.process
    end
  end
end
