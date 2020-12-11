# == Schema Information
#
# Table name: admin_users
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
#  is_active              :boolean          default(TRUE), not null
#  is_deleted             :boolean          default(FALSE), not null
#  deleted_by             :integer
#  created_at             :datetime
#  updated_at             :datetime
#
class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :omniauthable and :recoverable,
  devise :database_authenticatable,
          :rememberable, :validatable, :trackable

  ## Validations
  validates :first_name, :last_name, :email, presence: true
  validates_uniqueness_of :email

  ## Scope
  default_scope { where(is_deleted: false) }
  scope :active, -> { where(is_active: true) }

  ## Allow Only Active Users to Login
  def active_for_authentication?
    super && is_active?
  end
end
