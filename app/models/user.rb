# == Schema Information
#
# Table name: users
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
#  role                   :integer
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  is_invited             :boolean          default(FALSE)
#  invited_by_id          :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable, :validatable and :database_authenticatable_for_admin

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable,
         :authentication_keys => [:email, :organization_id, :role]

  ## ENUM
  enum role: [:admin, :participant]

  ## Associations
  belongs_to :organization, optional: true
  has_one :organization_admin, dependent: :destroy
  has_many :campaign_users, dependent: :destroy
  has_many :campaigns, through: :campaign_users
  # has_many :rewards, through: :reward_participants
  # has_many :reward_participants, dependent: :destroy
  # has_many :coupons, through: :reward_participants
  has_many :notes, dependent: :destroy

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
  validates :organization_id, presence: true, if: :invited?

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
  validates_presence_of :password, if: :password_required?
  validates_confirmation_of :password, if: :confirmation_password_required?
  validates_length_of :password, within: 8..20, allow_blank: true, if: :password_required?
  validate :password_complexity

  def password_complexity
    return if password.blank? || password =~ PASSWORD_VALIDATOR

    errors.add :password,
               'Complexity requirement not met. Must contain 3 of the following 4: <BR />1) A lowercase letter,
                <BR />2) An uppercase letter, <BR />3) A digit, <BR />4) A non-word character or symbol'
  end

  ## Allow Only Active Users to Login
  def active_for_authentication?
    super && is_active?
  end

  def password_required?
    self.is_invited? ? (self.confirmed? ? confirmation_password_required? : false) : true
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

  ## Check if User is organization Admin or Not
  def organization_admin? organization
    organization.present? && OrganizationAdmin.where(user_id: self.id, organization_id: organization.id).count > 0
  end

  ## Get Campaign User for an Organization
  def campaign_users organization
      CampaignUser.joins(:campaign).where(campaigns: {organization_id: organization.id, is_active: true},
                                          campaign_users: {user_id: self.id}).where.not(campaign_users: {role: 0})
  end


  ## Facebook Account Connect for Campaign user
  def self.facebook_connect(auth, params, user_agent = '', remote_ip = '', u_id = nil)
    org = Organization.where(id: params['oi']).first rescue nil
    camp = org.campaigns.where(id: params['ci']).first rescue nil if org.present?
    user = User.where(organization_id: org.try(:id), id: u_id).first

    Rails.logger.info "*********** Save Token *************"
    Rails.logger.info "*********** Response: #{auth} *************"
    Rails.logger.info "*********** Parameters: #{params} *************"

    if org.present? && camp.present? && user.present?
      ## Save the token response and user info details
      network = campaing.networks.new(platform: auth.provider, auth_token: auth.credentials.token, username: auth.info.name)
      Rails.logger.info "******* Network:  #{network} ************"
      if false
        network
      else
        Network.new
      end
    else
      Network.new
    end
  end

end
