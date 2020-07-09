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
#  avatar                 :string
#  status                 :integer          default("inactive")
#  twitter_uid            :string
#  twitter_token          :string
#  twitter_secret         :string
#  country                :string
#  home_phone             :string
#  work_phone             :string
#  job_position           :string
#  job_company_name       :string
#  job_industry           :string
#  email_setting_id       :integer
#  provider               :string           default("email")
#  uid                    :string
#  tokens                 :text
#
class Participant < ApplicationRecord
  include DeviseTokenAuth::Concerns::User

  ## Devise Configurations
  devise :database_authenticatable, :registerable, :confirmable, :trackable,
         :recoverable, :rememberable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2, :twitter],
         :authentication_keys => [:email, :organization_id, :campaign_id],
         :reset_password_keys => [:email, :organization_id, :campaign_id]

  ## Associations
  belongs_to :organization
  belongs_to :campaign
  has_many :submissions, dependent: :destroy
  has_many :participant_actions, dependent: :destroy
  has_many :participant_profiles, dependent: :destroy
  has_many :reward_participants, dependent: :destroy
  has_many :rewards, through: :reward_participants
  has_many :coupons, through: :reward_participants
  has_many :notes, dependent: :destroy
  has_many :sweepstake_entries, dependent: :destroy
  has_many :participant_device_tokens, dependent: :destroy
  belongs_to :email_setting, optional: true
  has_many :participant_profiles, dependent: :destroy
  has_many :participant_answers, dependent: :destroy

  ## Callbacks
  after_create :generate_participant_id
  after_save :check_milestone_reward

  ## ENUM
  enum connect_type: {facebook: 0, google: 1, email: 2}
  enum status: {inactive: 0, active: 1, opted_out: 2, blocked: 3}

  ## Mount Uploader for File Upload
  mount_uploader :avatar, AvatarUploader

  ## Nested Attributes
  accepts_nested_attributes_for :participant_profiles, allow_destroy: true, :reject_if => :all_blank

  ## Tags
  acts_as_taggable_on :tags

  ## Scopes
  scope :active, -> { where(arel_table[:status].eq(1)) }

  ## Allow Only Active Users to Login
  def active_for_authentication?
    super && (status == "active" || status == "opted_out")
  end

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

  ## For Adding Status Column to Datatable JSO Response
  def as_json(*)
    super.tap do |hash|
      hash['name'] = full_name
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  ## Facebook OmniAuth
  def self.facebook_omniauth(auth, params, user_agent = '', remote_ip = '')
    org = Organization.where(id: params['oi']).first rescue nil
    camp = org.campaigns.where(id: params['ci']).first rescue nil if org.present?
    participant = Participant.where(organization_id: org.id, campaign_id: camp.id, facebook_uid: auth['uid']).first

    if participant.present?
      [Participant.new, 'Sorry! You are not authorised to Login.'] unless participant.active_for_authentication?
    else
      participant = Participant.where(organization_id: org.id, campaign_id: camp.id, email: auth.info.email).first
    end

    if participant.present?
      participant.facebook_uid = auth.uid
      participant.facebook_token = auth.credentials.token
      participant.facebook_expires_at = Time.at(auth.credentials.expires_at)
      participant.connect_type = 'facebook'
      participant.remote_avatar_url = auth.info.image
      participant.status = 1
    else
      name = auth.info.name.split(" ")

      params = {
          organization_id: org.id,
          campaign_id: camp.id,
          facebook_uid: auth.uid,
          email: auth.info.email,
          password: Devise.friendly_token[0, 20],
          status: 1,
          first_name: name[0],
          last_name: name[1],
          facebook_token: auth.credentials.token,
          facebook_expires_at: Time.at(auth.credentials.expires_at),
          confirmed_at: DateTime.now,
          connect_type: 'facebook',
          remote_avatar_url: auth.info.image
      }

      participant = Participant.new(params)
      participant.skip_confirmation!
    end

    if participant.save(:validate => false)
      participant.connect_challenge_completed(user_agent, remote_ip, 'facebook')
      participant
    else
      [Participant.new, 'Connect via Facebook failed.']
    end
  end

  ## Google OmniAuth
  def self.google_omniauth(auth, params, user_agent = '', remote_ip = '')
    org = Organization.where(id: params['oi']).first rescue nil
    camp = org.campaigns.where(id: params['ci']).first rescue nil if org.present?

    participant = Participant.where(organization_id: org.id, campaign_id: camp.id, google_uid: auth['uid']).first
    if participant.present?
      [Participant.new, 'Sorry! You are not authorised to Login.'] unless participant.active_for_authentication?
    else
      participant = Participant.where(organization_id: org.id, campaign_id: camp.id, email: auth.info.email).first
    end

    refresh_token = auth.credentials.refresh_token.present?

    if participant.present?
      participant.google_uid = auth.uid
      participant.google_token = auth.credentials.token
      participant.google_refresh_token = auth.credentials.refresh_token if refresh_token
      participant.google_expires_at = Time.at(auth.credentials.expires_at)
      participant.connect_type = 'google'
      participant.status = 1
      participant.remote_avatar_url = auth.info.image
    else
      params = {
          organization_id: org.id,
          campaign_id: camp.id,
          google_uid: auth.uid,
          email: auth.info.email,
          password: Devise.friendly_token[0, 20],
          status: 1,
          first_name: auth.info.first_name,
          last_name: auth.info.last_name,
          google_token: auth.credentials.token,
          google_refresh_token: auth.credentials.refresh_token,
          google_expires_at: Time.at(auth.credentials.expires_at),
          confirmed_at: DateTime.now,
          connect_type: 'google',
          remote_avatar_url: auth.info.image
      }

      participant = Participant.new(params)
      participant.skip_confirmation!
    end

    if participant.save(:validate => false)
      participant.connect_challenge_completed(user_agent, remote_ip, 'google')
      participant
    else
      [Participant.new, 'Connect via Google failed.']
    end
  end

  ## Facebook Account Connect
  def self.facebook_connect(auth, params, user_agent = '', remote_ip = '', p_id = nil)
    org = Organization.where(id: params['oi']).first rescue nil
    camp = org.campaigns.where(id: params['ci']).first rescue nil if org.present?
    participant = Participant.where(organization_id: org.id, campaign_id: camp.id, id: p_id).first

    if participant.present?
      participant.facebook_uid = auth.uid
      participant.facebook_token = auth.credentials.token
      participant.facebook_expires_at = Time.at(auth.credentials.expires_at)

      if participant.save(:validate => false)
        participant.connect_challenge_completed(user_agent, remote_ip, 'connect', 'facebook')
        participant
      else
        Participant.new
      end
    else
      Participant.new
    end
  end

  ## Twitter Account Connect
  def self.twitter_connect(auth, params, user_agent = '', remote_ip = '', p_id = nil)
    org = Organization.where(id: params['oi']).first rescue nil
    camp = org.campaigns.where(id: params['ci']).first rescue nil if org.present?
    participant = Participant.where(organization_id: org.id, campaign_id: camp.id, id: p_id).first

    if participant.present?
      participant.twitter_uid = auth.uid
      participant.twitter_token = auth.credentials.token
      participant.twitter_secret = auth.credentials.token

      if participant.save(:validate => false)
        participant.connect_challenge_completed(user_agent, remote_ip, 'connect', 'twitter')
        participant
      else
        Participant.new
      end
    else
      Participant.new
    end
  end

  ## Facebook Account Connect
  def self.facebook_connect(auth, params, user_agent = '', remote_ip = '', p_id = nil)
    org = Organization.where(id: params['oi']).first rescue nil
    camp = org.campaigns.where(id: params['ci']).first rescue nil if org.present?
    participant = Participant.where(organization_id: org.id, campaign_id: camp.id, id: p_id).first

    if participant.present?
      participant.facebook_uid = auth.uid
      participant.facebook_token = auth.credentials.token
      participant.facebook_expires_at = Time.at(auth.credentials.expires_at)

      if participant.save(:validate => false)
        participant.connect_challenge_completed(user_agent, remote_ip, 'connect', 'facebook')
        participant
      else
        Participant.new
      end
    else
      Participant.new
    end
  end

  ## Twitter Account Connect
  def self.twitter_connect(auth, params, user_agent = '', remote_ip = '', p_id = nil)
    org = Organization.where(id: params['oi']).first rescue nil
    camp = org.campaigns.where(id: params['ci']).first rescue nil if org.present?
    participant = Participant.where(organization_id: org.id, campaign_id: camp.id, id: p_id).first

    if participant.present?
      participant.twitter_uid = auth.uid
      participant.twitter_token = auth.credentials.token
      participant.twitter_secret = auth.credentials.token

      if participant.save(:validate => false)
        participant.connect_challenge_completed(user_agent, remote_ip, 'connect', 'twitter')
        participant
      else
        Participant.new
      end
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
  def connect_challenge_completed(user_agent = '', remote_ip = '', connect_type = '', platform = '')
    ## Fetch the Campaign
    campaign = Campaign.where(id: self.campaign_id).first
    if campaign.present?
      ## Fetch the Challenge (Facebook, Google, Email)
      platform = (platform.present? && connect_type == 'connect') ? platform : self.connect_type
      challenge = campaign.challenges.current_active.where(challenge_type: %w[signup connect], parameters: platform).first

      if challenge.present?
        ## Check if the Challenge is Submitted Previously
        is_submitted = Submission.where(campaign_id: campaign.id, participant_id: self.id, challenge_id: challenge.id).present?
        action_type = if connect_type == 'connect'
                        'connect'
                      else
                        connect_type == 'email' ? 'sign_up' : 'sign_in'
                      end

        action_title = if platform.present? && connect_type == 'connect'
                         "Connected #{platform}"
                       else
                         connect_type == 'email' ? 'Signed up' : 'Signed in'
                       end

        if is_submitted
          ## Create Participant Action Log
          action_item = ParticipantAction.new({participant_id: self.id, points: 0, action_type: action_type,
                                               title: action_title, user_agent: user_agent, ip_address: remote_ip,
                                               campaign_id: self.campaign_id})
          action_item.save
        else
          ## Submit Challenge
          submit = Submission.new({campaign_id: campaign.id, participant_id: self.id, challenge_id: challenge.id,
                                   user_agent: user_agent, ip_address: remote_ip})
          submit.save

          ## Create Participant Action Log
          sign_up_log = ParticipantAction.new({participant_id: self.id, points: challenge.points.to_i,
                                               action_type: action_type, title: action_title, actionable_id: challenge.id,
                                               actionable_type: 'Challenge', details: challenge.caption,
                                               user_agent: user_agent, ip_address: remote_ip, campaign_id: self.campaign_id})
          sign_up_log.save
        end
      end
    end
  end

  ## Challenge Filter
  def self.side_bar_filter(filters)
    query = 'id IS NOT NULL'
    tags_query = ''
    gender = []
    challenges = []
    rewards = []

    filters.each do |key, value|
      if key == 'gender' && value.present?
        value.each do |c_type|
          gender << c_type
        end
        query = query + ' AND gender IN (:gender)'
      elsif key == 'tags' && value.present?
        value.each do |tag|
          tags_query = tags_query + " AND EXISTS (SELECT * FROM taggings WHERE taggings.taggable_id = participants.id AND taggings.taggable_type = 'Participant'" +
              " AND taggings.tag_id IN (SELECT tags.id FROM tags WHERE (LOWER(tags.name) ILIKE '#{tag}' ESCAPE '!')))"
        end
        query = query + tags_query
      elsif key == 'challenges' && value.present?
        challenges = Submission.where(challenge_id: value).pluck(:participant_id)
        query = query + ' AND id IN (:challenge_participants)'
      elsif key == 'rewards' && value.present?
        rewards = RewardParticipant.where(reward_id: value).pluck(:participant_id)
        query = query + ' AND id IN (:reward_participants)'
      elsif key == 'age' && value.present?
        query = query + " AND (age >= #{value[0]} AND age <= #{value[1]})"
      end
    end

    participants = self.where(query, gender: gender.flatten, challenge_participants: challenges.flatten, reward_participants: rewards)

    return participants
  end

  def full_address
    if address_1.present? || address_2.present? || city.present? || state.present? || postal.present?
      [address_1, address_2, city, state, postal].join(', ')
    else
      ''
    end
  end

  ## Check if Participant is Eligible for Challenge
  def eligible?(challenge)
    ## Set Result, By Default it is TRUE
    result = true
    result_array = []

    # Loop Through the Challenge User Segments
    challenge.challenge_filters.each do |filter|
      result_array.push(filter.available? self)
    end

    ## Check If We need to Include ALL/ANY User Segments
    if challenge.filter_type == 'all_filters'
      result = !result_array.include?(false)
    else
      result = result_array.include?(true)
    end

    result
  end

  # Class Methods
  class <<  self
    # For Gender Breakdown
    def by_gender(participants)
      gender = []
      gender << where(gender: 'male').count
      gender << where(gender: 'female').count
      gender << where(gender: 'other').count
    end

    # For Age Breakdown
    def by_age(participants)
      age = []
      age << where(age: 0..20).count
      age << where(age: 21..40).count
      age << where(age: 41..60).count
      age << where(age: 61..80).count
      age << where(age: 81..100).count
      age << where("age > ?", 100).count
    end

    # For Completed Challenges / Platform With Facebook & Google
    def by_completed_challenges(campaign)
      completed_challenges = []
      completed_challenges << campaign.challenges.where(challenge_type: 'share', parameters: 'twitter').count
      completed_challenges << campaign.challenges.where(challenge_type: 'share', parameters: 'facebook').count
      completed_challenges << campaign.challenges.where(challenge_type: 'share', parameters: 'google').count
    end

    # For Connected Platforms With Facebook & Google
    def by_connected_platform
      connected_platform = [5] # Test value for twitter
      connected_platform << where.not('participants.facebook_uid' => nil).count
      connected_platform << where.not('participants.google_uid' => nil).count
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
