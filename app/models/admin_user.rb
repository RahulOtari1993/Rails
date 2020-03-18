class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable, :trackable

  ## Validations
  validates :first_name, :last_name, presence: true

  ## Scope
  default_scope { where(is_deleted: false) }
  scope :active, -> { where(is_active: true) }
end
