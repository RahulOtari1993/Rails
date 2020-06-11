# == Schema Information
#
# Table name: campaign_template_details
#
#  id                      :bigint           not null, primary key
#  campaign_id             :bigint
#  favicon_file            :string
#  footer_background_color :string
#  footer_font_color       :string
#  footer_font_size        :float
#  header_background_image :string
#  header_logo             :string
#  header_text             :string
#  header_font_color       :string
#  header_font_size        :float
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  header_description      :text
#
class CampaignTemplateDetail < ApplicationRecord
  ## Associations
  belongs_to :campaign

  ## Mount Uploader for File Upload
  mount_uploader :header_background_image, ImageUploader
  mount_uploader :header_logo, ImageUploader
  mount_uploader :favicon_file, ImageUploader

end
