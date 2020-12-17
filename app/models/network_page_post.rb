# == Schema Information
#
# Table name: network_page_posts
#
#  id              :bigint           not null, primary key
#  network_id      :bigint
#  network_page_id :bigint
#  post_id         :text
#  message         :text
#  created_time    :datetime
#  title           :text
#  post_type       :integer
#  url             :text
#  total_likes     :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class NetworkPagePost < ApplicationRecord
  ## Associations
  belongs_to :network
  belongs_to :network_page
  has_many :network_page_post_attachments
  has_many :network_page_post_attachments, dependent: :destroy

  ## ENUM
  enum post_type: {photo: 0, album: 1, video: 2}
end
