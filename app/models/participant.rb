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
#
class Participant < ApplicationRecord
  ## Devise Configurations
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2],
         :authentication_keys => [:email, :organization_id, :campaign_id],
         :reset_password_keys => [:email, :organization_id, :campaign_id]

  ## Associations
  has_and_belongs_to_many :campaigns
  belongs_to :organization
  has_many :challenge_participants, dependent: :destroy
  has_many :challenges, through: :challenge_participants

  ## Callbacks
  after_create :save_participant_details
  after_create :generate_participant_id

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
                          scope: [:organization_id],
                          message: "Email already exists for this organization"

  validates_format_of :email,
                      with: /\A[^@]+@[^@]+\z/,
                      allow_blank: true,
                      if: :email_changed?

  ## Password Validations
  validates_presence_of :password
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
  def self.facebook_omniauth(auth, params)
    org = Organization.where(id: params['oi']).first rescue nil
    camp = org.campaigns.where(id: params['ci']).first rescue nil if org.present?
    participant = Participant.where(organization_id: org.id, campaign_id: camp.id, facebook_uid: auth['uid']).first
    unless participant.present?
      participant = Participant.where(organization_id: org.id, campaign_id: camp.id, email: auth.info.email).first
    end

    Rails.logger.info "************************* FB AUTO INFO --> #{auth.info} *************************"
    Rails.logger.info "************************* FB AUTO facebook_uid --> #{auth.uid} *************************"
    Rails.logger.info "************************* FB AUTO facebook_token --> #{auth.credentials.token} *************************"
    Rails.logger.info "************************* FB AUTO facebook_expires_at --> #{auth.credentials.expires_at} *************************"

    if participant.present?
      participant.facebook_uid = auth.uid
      participant.facebook_token = auth.credentials.token
      participant.facebook_expires_at = Time.at(auth.credentials.expires_at)
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
          confirmed_at: DateTime.now
      }
      Rails.logger.info "************************* Facebook Params --> #{params} *************************"

      participant = Participant.new(params)
      participant.skip_confirmation!
    end

    if participant.save(:validate => false)
      participant
    else
      Participant.new
    end
  end

  ## Google OmniAuth
  def self.google_omniauth(auth, params)
    org = Organization.where(id: params['oi']).first rescue nil
    camp = org.campaigns.where(id: params['ci']).first rescue nil if org.present?

    participant = Participant.where(organization_id: org.id, campaign_id: camp.id, google_uid: auth['uid']).first
    unless participant.present?
      participant = Participant.where(organization_id: org.id, campaign_id: camp.id, email: auth.info.email).first
    end

    Rails.logger.info "************************* Google AUTO INFO --> #{auth.info} *************************"
    Rails.logger.info "************************* Google AUTO Google_uid --> #{auth.uid} *************************"
    Rails.logger.info "************************* Google AUTO Google_token --> #{auth.credentials.token} *************************"
    Rails.logger.info "************************* Google AUTO Google_refresh_token --> #{auth.credentials.refresh_token} *************************"
    Rails.logger.info "************************* Google AUTO Google_expires_at --> #{auth.credentials.expires_at} *************************"
    refresh_token = auth.credentials.refresh_token.present?
    Rails.logger.info "************************* Google AUTO TOKEN PRESENT --> #{refresh_token} *************************"

    if participant.present?
      participant.google_uid = auth.uid
      participant.google_token = auth.credentials.token
      participant.google_refresh_token = auth.credentials.refresh_token if refresh_token
      participant.google_expires_at = Time.at(auth.credentials.expires_at)
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
          confirmed_at: DateTime.now
      }

      Rails.logger.info "************************* Google Params --> #{params} *************************"

      participant = Participant.new(params)
      participant.skip_confirmation!
    end

    if participant.save(:validate => false)
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

  private
    def generate_participant_id
      self.update_attribute('p_id', Participant.get_participant_id)
    end

    def save_participant_details
      campaign = Campaign.find(self.campaign_id)
      campaign.participants << self
    end
end
