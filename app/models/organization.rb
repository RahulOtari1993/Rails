class Organization < ApplicationRecord

  ## Validations
  validates :name, :sub_domain, :admin_user_id, presence: true
end
