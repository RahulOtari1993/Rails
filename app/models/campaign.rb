# == Schema Information
#
# Table name: campaigns
#
#  id                  :bigint           not null, primary key
#  organization_id     :bigint
#  name                :string           not null
#  domain              :string           not null
#  domain_type         :integer          not null
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
#  is_active           :boolean          default(TRUE)
#  template            :text
#  templated           :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  general_title       :string
#  my_account_title    :string
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
  has_one  :campaign_template_detail, dependent: :destroy
  has_and_belongs_to_many :participants, dependent: :destroy
  has_one :campaign_config, dependent: :destroy
  has_many :profile_attributes, dependent: :destroy
  has_many :networks, dependent: :destroy

  enum domain_type: [:sub_domain, :include_in_domain]

  ## Callbacks
  after_create :assign_admins
  after_create :set_template_design
  after_create :create_configs
  after_create :create_profile_attributes

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

  ## Assign Admins to a Newly Created Campaign
  def assign_admins
    self.organization.admins.each do |admin|
      self.campaign_users.create(user_id: admin.id, role: 1)
    end
  end

  ## Create & Set Template Details Entry for a Newly Created Campaign
  def set_template_design
    CampaignTemplateDetail.create!(campaign_id: self.id)
  end

  ## Create Empty Campaign Configs for Newly Created Campaign
  def create_configs
    CampaignConfig.create(campaign_id: self.id)
  end

  ## Create Profile Attributes Newly Created Campaign
  def create_profile_attributes
    profile_attributes = ProfileAttributeService.new(self.id)
    profile_attributes.process_records
  end
end
