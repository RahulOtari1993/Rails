class Participant < ApplicationRecord
	has_and_belongs_to_many :campaigns
	belongs_to :organization

	devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable,:omniauthable, :omniauth_providers => [:facebook, :google_oauth2],
         :authentication_keys => [:email, :organization_id], :reset_password_keys => [:email, :organization_id]

    validates :email, confirmation: true

    after_create :save_participant_details

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
  validates :first_name, :last_name, presence: true

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

  def invited?
    is_invited?
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  #facebook omniauth
  def self.from_omniauth(auth)
    participant = find_or_create_by(uid: auth[‘uid’], provider:  auth[‘provider’])
    if Participant.exists?(participant)
      participant
    else
      where(auth.slice(:provider, :uid)).first_or_initialize.tap do |participant|
        participant.provider = auth.provider
        participant.uid = auth.uid
        participant.name = auth.info.name
        participant.oauth_token = auth.credentials.token
        participant.oauth_expires_at = Time.at(auth.credentials.expires_at)
        participant.save!
      end
    end
  end

  private
   def save_participant_details
   	  campaign = Campaign.find(self.campaign_id)
   	  campaign.participants << self
   end
end
