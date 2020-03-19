class OrganizationAdmin < ApplicationRecord
  ## Associations
  belongs_to :user
  belongs_to :organization

  validates_uniqueness_of :user_id, :scope => :organization_id
end
