class Organization < ApplicationRecord

  ## Validations
  validates :name, :sub_domain, :admin_user_id, presence: true

  ## Scope
  default_scope { where(is_deleted: false) }
  scope :active, -> { where(is_active: true) }

end
