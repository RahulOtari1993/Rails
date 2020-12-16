class AddAttachmentIdInnetworkPagePostAttachments < ActiveRecord::Migration[5.2]
  def change
    add_column :network_page_post_attachments, :attachment_id, :string
  end
end
