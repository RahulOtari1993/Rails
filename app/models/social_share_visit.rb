# == Schema Information
#
# Table name: social_share_visits
#
#  id                :bigint           not null, primary key
#  referral_code_id  :integer
#  referral_code_str :string
#  participant_id    :integer
#  shareable_id      :integer
#  shareable_type    :string
#  referrer_url      :text
#  useragent         :text
#  ipaddress         :string(255)
#  utm_source        :string
#  utm_medium        :string
#  utm_term          :string
#  utm_content       :string
#  utm_name          :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  ahoy_visit_id     :integer
#
class SocialShareVisit < ApplicationRecord

  belongs_to :shareable, polymorphic: true, optional: true
  belongs_to :participant, optional: true
  belongs_to :referral_code, optional: true

  #validates :referral_code, uniqueness: { scope: [:participant_id] }, if: -> { !participant_id.blank? }

end
