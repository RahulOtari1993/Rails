# == Schema Information
#
# Table name: rewards
#
#  id                  :bigint           not null, primary key
#  campaign_id         :bigint
#  name                :string
#  limit               :integer
#  threshold           :integer
#  description         :text
#  image_file_name     :string
#  image_file_size     :decimal(, )
#  image_content_type  :string
#  selection           :string
#  start               :datetime
#  finish              :datetime
#  feature             :boolean
#  points              :integer
#  is_active           :boolean
#  redeption_details   :text
#  description_details :text
#  terms_conditions    :text
#  sweepstake_entry    :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Reward < ApplicationRecord
  ## Associations
  belongs_to :campaign
  has_many :coupons

  mount_uploader :image, ImageUploader

  SELECTIONS = [
		"manual"    ,
		"redeem"    ,
		"instant"   ,
		"threshold" ,
		"selection" ,
		"sweepstake",
	]

	FULFILMENTS = [
		"default" ,
		"badge"   ,
		"points"  ,
		"download"
	]
end
