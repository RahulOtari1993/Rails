class DomainList < ApplicationRecord
  belongs_to :organization
  belongs_to :campaign
end
