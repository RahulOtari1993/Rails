# == Schema Information
#
# Table name: organization_admins
#
#  id              :bigint           not null, primary key
#  organization_id :bigint           not null
#  user_id         :bigint           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class OrganizationAdmin < ApplicationRecord
  ## Associations
  belongs_to :admin, class_name: 'User', foreign_key: 'user_id'
  belongs_to :organization

  ## Callbacks
  after_create :assign_admins

  validates_uniqueness_of :user_id, :scope => :organization_id

  ## Assign Campaigns to a Newly Created Org Admin
  def assign_admins
    self.organization.campaigns.each do |campaign|
      campaign.campaign_users.create(user_id: self.user_id, role: 1)
    end
  end
end
