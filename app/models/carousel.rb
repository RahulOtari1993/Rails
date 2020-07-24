# == Schema Information
#
# Table name: carousels
#
#  id          :bigint           not null, primary key
#  title       :string
#  description :text
#  button_text :string
#  link        :string
#  image       :string
#  campaign_id :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Carousel < ApplicationRecord
  ## Associations
  belongs_to :campaign

  ## Validations
  validates :title, :description, :image, presence: true

  ## Mount Uploader for File Upload
  mount_uploader :image, ImageUploader
end
