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
  has_many :campaigns, dependent: :destroy
  has_many :rewards, dependent: :destroy
end
