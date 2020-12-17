class AddAttachmentIdInnetworkPagePostAttachments < ActiveRecord::Migration[5.2]
  def change
    Network.all.destroy_all

    add_column :network_page_post_attachments, :attachment_id, :string
    add_column :network_page_post_attachments, :image_source, :text

    remove_column :network_page_post_attachments, :media_type
    remove_column :network_page_post_attachments, :media_src
  end
end
