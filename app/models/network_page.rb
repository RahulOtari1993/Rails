class NetworkPage < ApplicationRecord
  belongs_to :campaign
  belongs_to :network

  has_many :network_page_posts, dependent: :destroy

end
