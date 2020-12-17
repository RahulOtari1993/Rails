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
#  attachment_id        :string
#
class NetworkPagePostAttachment < ApplicationRecord
  ## Associations
  belongs_to :network_page_post

  ## ENUM
  enum category: {photo: 0, video: 1}
end
