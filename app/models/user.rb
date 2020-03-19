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
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  first_name             :string
#  last_name              :string
#  is_active              :boolean          default("true"), not null
#  is_deleted             :boolean          default("false"), not null
#  deleted_by             :integer
#  organization_id        :integer
#  role                   :integer
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  is_invited             :boolean          default("false")
#  invited_by_id          :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable #, :validatable

  enum role: [:admin, :participant]

  ## Associations
  belongs_to :organization, optional: true
  has_one :organization_admin
  has_many :campaign_users, dependent: :destroy
  has_many :campaigns, through: :campaign_users
  has_many :submissions, dependent: :destroy

  # Validations
  validates :first_name, :last_name, presence: true
  validates :organization_id, presence: true, if: :invited?

  # From Devise module Validatable
  validates_presence_of :password, if: :password_required?

  validates_presence_of :email, if: :email_required?

  validates_uniqueness_of :email,
                          scope: [:organization_id],
                          message: "Email already exists for this organization"

  validates_format_of :email,
                      with: /\A[^@]+@[^@]+\z/,
                      allow_blank: true,
                      if: :email_changed?

  validates_confirmation_of :password, if: :confirmation_password_required?
  validates_length_of :password, within: 6..20, allow_blank: true


  def password_required?
    self.confirmed? ? confirmation_password_required? : false
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
end
