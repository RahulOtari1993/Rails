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
  has_many :admins, through: :organization_admins, class_name: 'User', foreign_key: 'user_id'
  has_many :campaigns, dependent: :destroy
  has_many :domain_lists, dependent: :destroy

  ## Validations
  validates :name, :sub_domain, :admin_user_id, presence: true
  validates :sub_domain, uniqueness: true
  validate :domain_uniqueness, on: :update

  ## Check Domain Uniqueness while Changing Organization Sub Domain
  def domain_uniqueness
    self.campaigns.each do |campaign|
      if campaign.domain_type == 'sub_domain'
        sub_domain = "#{self.sub_domain}.#{campaign.domain}"
      else
        sub_domain = "#{self.sub_domain}#{campaign.domain}"
      end

      domain_list = DomainList.where(domain: sub_domain).where.not(organization_id: self.id)
      if domain_list.present?
        errors.add :sub_domain, ' is already occupied, Please try other one'
        return
      end
    end
  end

  ## Scope
  default_scope { where(is_deleted: false) }
  scope :active, -> { where(is_active: true) }
end
