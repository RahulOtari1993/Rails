# == Schema Information
#
# Table name: organizations
#
#  id            :bigint           not null, primary key
#  name          :string           not null
#  sub_domain    :string           not null
#  admin_user_id :bigint           not null
#  is_active     :boolean          default("true"), not null
#  is_deleted    :boolean          default("false"), not null
#  deleted_by    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
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
