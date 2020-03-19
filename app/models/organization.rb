class Organization < ApplicationRecord
  ## Associations
  has_many :users, dependent: :destroy
  has_many :organization_admins, dependent: :destroy

  ## Validations
  validates :name, :sub_domain, :admin_user_id, presence: true
  validates :sub_domain, uniqueness: true

  ## Scope
  default_scope { where(is_deleted: false) }
  scope :active, -> { where(is_active: true) }

end
