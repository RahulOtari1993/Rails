# == Schema Information
#
# Table name: domain_lists
#
#  id              :bigint           not null, primary key
#  domain          :string
#  organization_id :bigint
#  campaign_id     :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class DomainList < ApplicationRecord
  belongs_to :organization
  belongs_to :campaign

  ## Validations
  validates :domain, :organization_id, :campaign_id, presence: true
  validates :domain, uniqueness: true
end
