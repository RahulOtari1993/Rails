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
#  provider               :string
#  uid                    :string
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
#  oauth_token            :string
#  oauth_expires_at       :datetime
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

  #facebook omniauth
  def self.from_omniauth(auth, params)
    org = Organization.where(id: params['oi']).first rescue nil
    camp = org.campaigns.where(id: params['ci']).first rescue nil if org.present?
    participant = Participant.where(organization_id: org.id, campaign_id: camp.id, uid: auth['uid']).first

    if participant.present?
      participant.oauth_token = auth.credentials.token
      participant.oauth_expires_at = Time.at(auth.credentials.expires_at)
    else
      params = {
          organization_id: org.id,
          campaign_id: camp.id,
          provider: auth.provider,
          uid: auth.uid,
          email: auth.info.email,
          password: Devise.friendly_token[0, 20],
          is_active: true,
          first_name: auth.info.name,
          oauth_token: auth.credentials.token,
          oauth_expires_at: Time.at(auth.credentials.expires_at),
          confirmed_at: DateTime.now
      }

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
    donation_id = SecureRandom.hex (6)
    p_id = self.where(p_id: donation_id.upcase)
    if p_id.present?
      generate_participant_id
    else
      donation_id.upcase
    end
  end

  private
    def generate_participant_id
      self.p_id = get_participant_id
      self.save
    end

    def save_participant_details
      campaign = Campaign.find(self.campaign_id)
      campaign.participants << self
    end
end
