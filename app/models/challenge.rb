# == Schema Information
#
# Table name: challenges
#
#  id                 :bigint           not null, primary key
#  campaign_id        :bigint
#  name               :text
#  start              :datetime
#  finish             :datetime
#  timezone           :string
#  points             :integer
#  challenge_type     :string
#  feature            :boolean
#  creator_id         :integer
#  approver_id        :integer
#  content            :text
#  link               :text
#  clicks             :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  description        :text
#  reward_type        :integer
#  reward_id          :bigint
#  is_approved        :boolean          default("false")
#  image              :string
#  social_title       :string
#  social_description :string
#  social_image       :string
#  login_count        :integer
#  title              :string
#  points_click       :string
#  points_maximum     :string
#  duration           :integer
#  parameters         :integer
#  category           :integer
#  address            :string
#  longitude          :decimal(, )
#  latitude           :decimal(, )
#  location_distance  :float
#

class Challenge < ApplicationRecord
  #TODO : While Approving a Challenge, Check if ORG do have Social Media Config Available
  #TODO : Validation Needs to be added

  ## Associations
  belongs_to :campaign
  has_many :challenge_filters, dependent: :destroy
  has_many :challenge_participants, dependent: :destroy
  has_many :participants, through: :challenge_participants

  ## Constants
  # MECHANISMS = %w(like rate form scorm login video share pixel manual signup follow article referal
  #                 comment connect hashtag referal location subscribe submission play practice hr link collect)

  CHALLENGE_TYPE = %w(share signup login video article referral location link engage survey quiz collect)
  RADIUS = [['0.1 Mile', 161], ['0.2 Mile', 321], ['0.3 Mile', 482], ['1 Mile', 1609], ['5 Mile', 8046], ["10 Mile", 16093]]

  ## ENUM
  enum reward_type: [:points, :prize]
  enum category: [:share, :engage, :amplify, :collection, :connect, :grow]
  enum parameters: [:facebook, :twitter, :linked_in, :youtube, :instagram, :google, :email, :profile, :custom]

  ## Mount Uploader for File Upload
  mount_uploader :image, ImageUploader
  mount_uploader :social_image, ImageUploader

  ## Nested Attributes for Challenge Filters
  accepts_nested_attributes_for :challenge_filters, allow_destroy: true, :reject_if => :all_blank

  ## GeoCoding
  # geocoded_by :address
  # reverse_geocoded_by :latitude, :longitude
  # after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  # after_validation :reverse_geocode, unless: ->(obj) { obj.address.present? },
  #                  if: ->(obj){ obj.latitude.present? and obj.latitude_changed? and obj.longitude.present? and obj.longitude_changed? }

  ## Validations
  validates :challenge_type, :parameters, :category, :name, :link, :description, :image, :social_title,
            :social_description, :start, :timezone, :creator_id, presence: true
  validate :reward_existence

  ## Check Whether Proper Inputs provided for Reward Type
  def reward_existence
    if self.reward_type == 'points'
      if !self.points.present?
        errors.add :points, " can't be blank"
        return
      end
    elsif self.reward_type == 'prize'
      if !self.reward_id.present?
        errors.add :reward_id, " must be selected"
        return
      end
    else
      errors.add :reward_type, ' is invalid'
      return
    end
  end

  ## Check Status of a Challenge [Draft, Active, Scheduled, Ended]
  def status
    if is_approved
      'active'
    else
      'draft'
    end
  end
end
