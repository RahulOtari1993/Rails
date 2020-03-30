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
  validates :domain, uniqueness: true

  # validate :domain_uniqueness
  #
  # def domain_uniqueness
  #
  #
  #   errors.add :password,
  #              'Complexity requirement not met. Must contain 3 of the following 4: 1) A lowercase letter, 2) An uppercase letter, 3) A digit, 4) A non-word character or symbol'
  # end
end
