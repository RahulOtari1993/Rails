class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable #, :validatable

  enum role: [:admin, :participant]

  ## Associations
  belongs_to :organization

  ## Validations
  validates :first_name, :last_name, :organization_id, presence: true

  # From Devise module Validatable
  validates_presence_of :password, if: :password_required?

  validates_presence_of   :email, if: :email_required?

  validates_uniqueness_of :email,
                          scope: [:organization_id],
                          message: "Email already exists for this organization"

  validates_format_of :email,
                      with: /\A[^@]+@[^@]+\z/,
                      allow_blank: true,
                      if: :email_changed?

  validates_confirmation_of :password, if: :confirmation_password_required?
  validates_length_of       :password, within: 6..20, allow_blank: true


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
end
