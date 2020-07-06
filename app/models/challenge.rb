# == Schema Information
#
# Table name: challenges
#
#  id                   :bigint           not null, primary key
#  campaign_id          :bigint
#  name                 :text
#  start                :datetime
#  finish               :datetime
#  timezone             :string
#  points               :integer
#  challenge_type       :string
#  feature              :boolean
#  creator_id           :integer
#  approver_id          :integer
#  content              :text
#  link                 :text
#  clicks               :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  description          :text
#  reward_type          :integer
#  reward_id            :bigint
#  is_approved          :boolean          default(FALSE)
#  image                :string
#  social_title         :string
#  social_description   :string
#  social_image         :string
#  login_count          :integer
#  title                :string
#  points_click         :string
#  points_maximum       :string
#  duration             :integer
#  parameters           :integer
#  category             :integer
#  address              :string
#  longitude            :float
#  latitude             :float
#  location_distance    :integer
#  filter_type          :integer          default("all_filters")
#  filter_applied       :boolean          default(FALSE)
#  caption              :string
#  icon                 :string
#  success_message      :string
#  failed_message       :string
#  correct_answer_count :integer
#  completions          :integer          default(0)
#

class Challenge < ApplicationRecord
  ## include ActiveModel::Serializers::JSON

  ## Associations
  belongs_to :campaign
  has_many :challenge_filters, dependent: :destroy
  has_many :submissions, dependent: :destroy
  has_many :participants, through: :submissions
  has_many :questions, dependent: :destroy
  belongs_to :reward, optional: true
  # attr_accessor :status

  ## Constants
  # MECHANISMS = %w(like rate form scorm login video share pixel manual signup follow article referal
  #                 comment connect hashtag referal location subscribe submission play practice hr link collect)

  CHALLENGE_TYPE = %w(share signup login video article referral location link engage collect)
  RADIUS = [['0.1 Mile', 161], ['0.2 Mile', 321], ['0.3 Mile', 482], ['1 Mile', 1609], ['5 Mile', 8046], ["10 Mile", 16093]]
  END_DATE_YEARS = 500

  ## ENUM
  enum reward_type: [:points, :prize]
  enum category: [:share, :engage, :amplify, :collection, :connect, :grow]
  enum parameters: [:facebook, :twitter, :linked_in, :youtube, :instagram, :google, :email, :profile, :custom, :quiz, :survey]
  enum filter_type: {all_filters: 0, any_filter: 1}

  ## Mount Uploader for File Upload
  mount_uploader :image, ImageUploader
  mount_uploader :social_image, ImageUploader
  mount_uploader :icon, IconUploader

  ## Nested Attributes
  accepts_nested_attributes_for :challenge_filters, allow_destroy: true, :reject_if => :all_blank
  accepts_nested_attributes_for :questions, allow_destroy: true, :reject_if => :all_blank

  ## Tags
  acts_as_taggable_on :tags

  ## Scopes
  # scope :scheduled, -> { where(self.start.in_time_zone(self.timezone) > Time.now.in_time_zone(self.timezone)) }
  scope :featured, -> { where(arel_table[:feature].eq(true)) }
  scope :current_active, -> { where("is_approved = true AND start AT TIME ZONE timezone <= timezone(timezone,now()) AND finish AT TIME ZONE timezone >= timezone(timezone,now())") }

  ## Validations
  validates :challenge_type, :category, :name, :description, :image, :start, :timezone, :creator_id, :icon,
            :caption, presence: true
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

  ## For Adding Status Column to Datatable JSO Response
  def as_json(*)
    super.tap do |hash|
      hash['status'] = status
      hash['reward_name'] = self.reward_type == 'prize' ? self.reward.name : ''
    end
  end

  ## Challenge Filter
  def self.challenge_side_bar_filter(filters)
    query = 'id IS NOT NULL'
    tags_query = ''
    status = []
    platform_type = []
    challenge_type = []
    reward_type = []

    filters.each do |key, value|
      if key == 'status' && value.present?
        status_query = ''
        value.each_with_index do |val, index|
          keyword = ' OR'
          if index == 0
            keyword = 'AND'
          end

          if val == 'draft'
            status_query = " #{keyword} (is_approved = false)"
          elsif val == 'active'
            status_query = status_query +
                " #{keyword} is_approved = true AND start AT TIME ZONE timezone <= timezone(timezone,now()) AND finish AT TIME ZONE timezone >= timezone(timezone,now())"

            ## Back up
            # status_query = status_query + " #{keyword} (is_approved = true AND start <= convert_tz('#{current_utc_time}', 'UTC', timezone) AND finish >= convert_tz('#{current_utc_time}', 'UTC', timezone))"
            # status_query = status_query + " #{keyword} (is_approved = true AND start <= convert_tz('#{current_utc_time}', 'UTC', timezone) AND finish >= convert_tz('#{current_utc_time}', 'UTC', timezone))"
          elsif val == 'scheduled'
            status_query = status_query +
                " #{keyword} is_approved = true AND start AT TIME ZONE timezone > timezone(timezone,now())"

            ## Back up
            # # status_query = status_query + " #{keyword} (is_approved = true AND start > convert_tz('#{current_utc_time}', 'UTC', timezone))"
            # #unix_timestamp(convert_tz(now(), 'UTC', offers.timezone))
            # status_query = " #{keyword} timezone(challenges.timezone, challenges.start) > :schedule"
            # ended_challenges = self.select{|challenge| challenge.finish.in_time_zone(challenge.timezone) < Time.now.in_time_zone(challenge.timezone)}
            # scheduled_keyword = Time.now.in_time_zone(self.timezone).to_i
          elsif val == 'ended'
            status_query = status_query +
                " #{keyword} is_approved = true AND finish AT TIME ZONE timezone < timezone(timezone,now())"

            ## Back up
            # status_query = status_query + " #{keyword} (is_approved = true AND finish > convert_tz('#{current_utc_time}', 'UTC', timezone))"
            # status_query = " #{keyword} convert_tz(challenges.finish, 'UTC') < :ended_keyword"
            # ended_keyword = Time.now.in_time_zone(self.timezone).to_i
          end
        end

        query = query + status_query
      elsif key == 'challenge_type' && value.present?
        value.each do |c_type|
          challenge_type << Challenge::categories[c_type]
        end
        query = query + ' AND category IN (:challenge_type)'
      elsif key == 'platform_type' && value.present?
        value.each do |c_type|
          platform_type << Challenge::parameters[c_type]
        end
        query = query + ' AND parameters IN (:platform_type)'
      elsif key == 'reward_type' && value.present?
        value.each do |c_type|
          reward_type << Challenge::reward_types[c_type]
        end
        query = query + ' AND parameters IN (:reward_type)'
      elsif key == 'tags' && value.present?
        value.each do |tag|
          tags_query = tags_query + " AND EXISTS (SELECT * FROM taggings WHERE taggings.taggable_id = challenges.id AND taggings.taggable_type = 'Challenge'" +
              " AND taggings.tag_id IN (SELECT tags.id FROM tags WHERE (LOWER(tags.name) ILIKE '#{tag}' ESCAPE '!')))"
        end

        query = query + tags_query
      end
    end
    challenges = self.where(query, is_approved: status, challenge_type: challenge_type.flatten,
                            platform_type: platform_type.flatten, reward_type: reward_type.flatten)
    return challenges
  end

  ## Check if Challenge is Available for Participant
  def available?
    ## Set Result, By Default it is TRUE
    result = true
    result_array = []

    # Loop Through the Filters
    self.challenge_filters.each do |filter|
      result_array.push(filter.available? Participant.current)
    end

    ## Check If We need to Include ALL/ANY Filter
    if self.filter_type == 'all_filters'
      result = !result_array.include?(false)
    else
      result = result_array.include?(true)
    end

    result
  end

  ## Fetch Total Earned Points By Users using a Challenge
  def earned_points
    ParticipantAction.where(actionable_type: self.class.to_s, actionable_id: self.id, campaign_id: self.campaign_id).sum(:points)
  end

  ## Returns the Targeted Participants
  def targeted_participants
    self.campaign.participants.where('created_at < ?', self.finish.end_of_day).select {|x| x.eligible? self }
  end

  # Calculate Months For Insight User
  def calculate_months
    months = Challenge.all.map {|c| [c.start.strftime('%b'),c.finish.strftime('%b')]}
    months.flatten.uniq
  end
end
