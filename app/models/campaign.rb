# == Schema Information
#
# Table name: campaigns
#
#  id                  :bigint           not null, primary key
#  organization_id     :bigint
#  name                :string
#  domain              :string
#  twitter             :string
#  rules               :text
#  privacy             :text
#  terms               :text
#  contact_us          :text
#  faq_title           :string
#  faq_content         :text
#  prizes_title        :string
#  general_content     :text
#  how_to_earn_title   :string
#  how_to_earn_content :text
#  css                 :text
#  seo                 :text
#  is_active           :boolean
#  template            :text
#  templated           :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Campaign < ApplicationRecord
  ## Associations
  belongs_to :organization
  has_many :challenges, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :campaign_users, dependent: :destroy
  has_many :users, through: :campaign_users
  has_many :submissions, dependent: :destroy
  has_one  :domain_list, dependent: :destroy

  enum domain_type: [:sub_domain, :include_in_domain]

  ## Validations
  validates :name, :domain, :organization_id, :domain_type, presence: true
  validates_exclusion_of :domain, in: Organization::EXCLUDED_SUBDOMAINS,
                         message: "is not allowed. Please choose another domain"
  validates_format_of :domain, with: Organization::DOMAIN_PATTERN,
                      message: "is not allowed. Please choose another subdomain."
  validate :domain_uniqueness

  ## Check Domain Uniqueness
  def domain_uniqueness
    org = self.organization
    if domain_type == 'sub_domain'
      sub_domain = "#{org.sub_domain}.#{domain}"
    else
      sub_domain = "#{org.sub_domain}#{domain}"
    end

    if self.new_record?
      domain_list = DomainList.where(domain: sub_domain)
    else
      domain_list = DomainList.where(domain: sub_domain).where.not(campaign_id: self.id)
    end

    if domain_list.present?
      errors.add :domain, ' is already occupied, Please try other one'
    end
  end
end
