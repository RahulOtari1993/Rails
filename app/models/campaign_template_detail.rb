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
#
class CampaignTemplateDetail < ApplicationRecord
  ## Associations
  belongs_to :campaign

  validates :favicon_file, :footer_background_color, presence: true
end
