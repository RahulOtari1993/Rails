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
#  is_approved        :boolean          default(FALSE)
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
#  longitude          :float
#  latitude           :float
#  location_distance  :integer
#  filter_type        :integer          default("all_filters")
#  filter_applied     :boolean          default(FALSE)
#

class Challenge < ApplicationRecord
  ## include ActiveModel::Serializers::JSON

  ## Associations
  belongs_to :campaign
  has_many :challenge_filters, dependent: :destroy
  has_many :challenge_participants, dependent: :destroy
  has_many :participants, through: :challenge_participants
  has_many :questions, dependent: :destroy
  # attr_accessor :status

  ## Constants
  # MECHANISMS = %w(like rate form scorm login video share pixel manual signup follow article referal
  #                 comment connect hashtag referal location subscribe submission play practice hr link collect)

  CHALLENGE_TYPE = %w(share signup login video article referral location link engage survey quiz collect)
  RADIUS = [['0.1 Mile', 161], ['0.2 Mile', 321], ['0.3 Mile', 482], ['1 Mile', 1609], ['5 Mile', 8046], ["10 Mile", 16093]]
  END_DATE_YEARS = 500

  ## ENUM
  enum reward_type: [:points, :prize]
  enum category: [:share, :engage, :amplify, :collection, :connect, :grow]
  enum parameters: [:facebook, :twitter, :linked_in, :youtube, :instagram, :google, :email, :profile, :custom]
  enum filter_type: {all_filters: 0, any_filter: 1}

  ## Mount Uploader for File Upload
  mount_uploader :image, ImageUploader
  mount_uploader :social_image, ImageUploader

  ## Nested Attributes for Challenge Filters
  accepts_nested_attributes_for :challenge_filters, allow_destroy: true, :reject_if => :all_blank

  ## Tags
  acts_as_taggable_on :tags

  ## Scopes
  scope :scheduled, -> { where(self.start.in_time_zone(self.timezone) > Time.now.in_time_zone(self.timezone)) }

  ## Validations
  validates :challenge_type, :category, :name, :description, :image, :start, :timezone, :creator_id, presence: true
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
    if is_approved && self.start.in_time_zone(self.timezone) > Time.now.in_time_zone(self.timezone)
      'scheduled'
    elsif is_approved && self.finish.in_time_zone(self.timezone) < Time.now.in_time_zone(self.timezone)
      'ended'
    elsif is_approved
      'active'
    else
      'draft'
    end
  end

  ##for adding status column to datatable json response
  def as_json(*)
    super.tap do |hash|
      hash["status"] = status
    end
  end

  ##challenge platform filter
  def self.challenge_side_bar_filter(filters)
    query = 'id IS NOT NULL'
    status_query_string = ''
    platform_query_string = ''
    type_query_string = ''
    tags_query = ''
    challenges = ''
    status = []
    parameters = []
    challenge_type = []
    active_keyword = ''
    scheduled_keyword = ''
    draft_keyword = ''
    ended_keyword = ''
    filters.each do |key, value|
      if key == 'status' && filters[key].present?
        # status_query_string = query_string + ' OR is_approved IS ? '
        value.each do |val|
          if val == 'draft'
            status_query_string = ' AND is_approved IS :draft_keyword'
            draft_keyword = false
          elsif val == 'active'
            status_query_string = status_query_string + ' AND is_approved IS :active_keyword'
            active_keyword = true
          elsif val == 'scheduled'
            #unix_timestamp(convert_tz(now(), 'UTC', offers.timezone))
            status_query_string = " AND timezone(challenges.timezone, challenges.start) > :schedule"
            # ended_challenges = self.select{|challenge| challenge.finish.in_time_zone(challenge.timezone) < Time.now.in_time_zone(challenge.timezone)}
            scheduled_keyword = Time.now.in_time_zone(self.timezone).to_i
          elsif val == 'ended'
            status_query_string = " AND convert_tz(challenges.finish, 'UTC') < :ended_keyword"
            ended_keyword = Time.now.in_time_zone(self.timezone).to_i
          end
        end
      elsif key == 'challenge_type' && filters[key].present?
        if Challenge.categories.values_at(*Array(value)).present?
          type_query_string = ' AND category IN (:challenge_type)'
          challenge_type << value
        end
      elsif key == 'platform_type' && filters[key].present?
        if Challenge.parameters.values_at(*Array(value)).present?
          platform_query_string = ' AND parameters IN (:parameters)'
          parameters << value
        end
      elsif key == 'tags' && filters[key].present?
        filters[key].each do |tag|
          tags_query = tags_query + " AND EXISTS (SELECT * FROM taggings WHERE taggings.taggable_id = challenges.id AND taggings.taggable_type = 'Challenge'" +
              " AND taggings.tag_id IN (SELECT tags.id FROM tags WHERE (LOWER(tags.name) ILIKE '#{tag}' ESCAPE '!')))"
        end
      end
    end
    final_query = query + status_query_string + type_query_string + platform_query_string + tags_query
    challenges = self.where(final_query, is_approved: status, challenge_type: challenge_type.flatten, parameters: Challenge.parameters.values_at(*Array(parameters.flatten))) #challenge_type: facebook_keyword, challenge_type:instagram_keyword, challenge_type: tumblr_keyword, challenge_type: twitter_keyword, challenge_type: pinterest_keyword )

    return challenges
  end
end
