class NetworkPagePost < ApplicationRecord
  belongs_to :network
  belongs_to :network_page

  has_many :network_page_post_attachments, dependent: :destroy

  enum post_type: [ :photo, :album, :video_inline ]

end
