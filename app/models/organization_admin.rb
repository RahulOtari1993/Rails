class OrganizationAdmin < ApplicationRecord
  ## Associations
  belongs_to :user
  belongs_to :organization
end
