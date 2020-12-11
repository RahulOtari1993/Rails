# == Schema Information
#
# Table name: network_pages
#
#  id                :bigint           not null, primary key
#  page_id           :string
#  page_name         :string
#  category          :string
#  page_access_token :text
#  campaign_id       :bigint
#  network_id        :bigint
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class NetworkPage < ApplicationRecord
  belongs_to :campaign
  belongs_to :network

  has_many :network_page_posts, dependent: :destroy

end
