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
#  redemption_details  :text
#  description_details :text
#  terms_conditions    :text
#  sweepstake_entry    :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  image               :string
#  notes               :text
#  msrp_value          :integer
#  bonus_points        :integer
#  photo_url           :text
#  thumb_url           :text
#  actual_image_url    :text
#  image_width         :integer
#  image_height        :integer
#
class Reward < ApplicationRecord
  ## Associations
  belongs_to :campaign
  has_many :coupons
  has_many :reward_filters, inverse_of: :reward
  has_many :reward_participants, dependent: :destroy
  has_many :users, through: :reward_participants
  has_many :coupons, :dependent => :delete_all
  has_many :reward_rules, :dependent => :delete_all

  has_one_attached :image
  has_one_attached :image_actual
  has_one_attached :photo_image
  has_one_attached :thumb_image

  serialize :image
  validates :image, presence: true

  accepts_nested_attributes_for :reward_filters, allow_destroy: true, :reject_if => :all_blank
  accepts_nested_attributes_for :reward_rules, allow_destroy: true, :reject_if => :all_blank

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

	

	validates :campaign, presence: true
	validates :name, presence: true
	validates :threshold, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, if: Proc.new { |x| x.selection == "selection" }
	validates :selection, presence: true, inclusion: SELECTIONS
	# validates :fulfilment, presence: true, inclusion: FULFILMENTS
	validates :description, presence: true
end
