# == Schema Information
#
# Table name: network_page_post_attachments
#
#  id                   :bigint           not null, primary key
#  network_page_post_id :bigint
#  height               :integer
#  width                :integer
#  media_src            :text
#  media_type           :integer
#  category             :integer
#  url                  :text
#  video_source         :text
#  likes                :integer
#  target               :json
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class NetworkPagePostAttachment < ApplicationRecord
  belongs_to :network_page_post

  enum media_type: [ :image, :video ]

  enum category: [ :photo, :video_inline ]
end
