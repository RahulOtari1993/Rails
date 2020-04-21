# == Schema Information
#
# Table name: challenges
#
#  id                 :bigint           not null, primary key
#  campaign_id        :bigint
#  name               :text
#  platform           :integer
#  start              :datetime
#  finish             :datetime
#  timezone           :string
#  points             :integer
#  parameters         :string
#  mechanism          :string
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
#  is_draft           :boolean          default("true")
#  image              :string
#  social_title       :string
#  social_description :string
#
class Challenge < ApplicationRecord
  #TODO : While Approving a Challenge, Check if ORG do have Social Media Config Available
  #TODO : Validation Needs to be added

  ## Associations
  belongs_to :campaign
  has_many :challenge_filters, dependent: :destroy

  ## Constants
  MECHANISMS = %w(like rate form scorm login video share pixel manual signup follow article referal
                  comment connect hashtag referal location subscribe submission play practice hr link engage collect)

  ## ENUM
  enum reward_type: [:points, :prize]
  enum platform: [:facebook, :twitter, :linked_in]

  ## Mount Uploader for File Upload
  mount_uploader :image, ImageUploader

  ## Nested Attributes for Challenge Filters
  accepts_nested_attributes_for :challenge_filters, allow_destroy: true, :reject_if => :all_blank

  ## Validations
  validates :mechanism, :name, :link, :description, :platform, :image, :social_title, :social_description,
            :start, :timezone, presence: true
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
end
