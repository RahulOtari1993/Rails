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

  validates_uniqueness_of :user_id, :scope => :organization_id
end
