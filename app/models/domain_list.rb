class DomainList < ApplicationRecord
  belongs_to :organization
  belongs_to :campaign

  ## Validations
  validates :domain, :organization_id, :campaign_id, presence: true
  validates :domain, uniqueness: true
end
