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
  belongs_to :network
  belongs_to :network_page
  has_many :network_page_post_attachments

  has_many :network_page_post_attachments, dependent: :destroy

  enum post_type: [ :photo, :album, :video_inline, :image, :video, :carousel_album ]

end
