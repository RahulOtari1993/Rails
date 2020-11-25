class NetworkPagePostAttachment < ApplicationRecord
  belongs_to :network_page_post

  enum media_type: [ :image, :video ]

  enum category: [ :photo, :video_inline ]
end
