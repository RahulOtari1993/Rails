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
#  identifier           :string
#  use_short_url        :boolean          default(FALSE), not null
#  post_view_points     :integer
#  post_like_points     :integer
#  how_many_posts       :integer
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
  has_many :participant_actions, as: :actionable
  has_many :participant_answers, dependent: :destroy

  has_many :social_challenge_post_visits

  ## Constants
  # MECHANISMS = %w(like rate form scorm login video share pixel manual signup follow article referal
  #                 comment connect hashtag referal location subscribe submission play practice hr link collect)

  CHALLENGE_TYPE = %w(share signup login video article referral location link engage collect connect)
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

  ## Callbacks
  after_create :generate_challenge_identifier

  ## Nested Attributes
  accepts_nested_attributes_for :challenge_filters, allow_destroy: true, :reject_if => :all_blank
  accepts_nested_attributes_for :questions, allow_destroy: true, :reject_if => :all_blank

  ## Tags
  acts_as_taggable_on :tags

  ## Scopes
  # scope :scheduled, -> { where(self.start.in_time_zone(self.timezone) > Time.now.in_time_zone(self.timezone)) }
  scope :featured, -> { where(arel_table[:feature].eq(true)) }
  scope :current_active, -> { where("is_approved = true AND start <= timezone(timezone,now()) AND finish >= timezone(timezone,now())") }

  scope :referral_default_challenge, -> { where(challenge_type: 'referral').where(parameters: :custom).where(is_approved: true) }
  scope :referral_social_challenges, -> { where(challenge_type: 'referral').where.not(parameters: :custom).where(is_approved: true) }
  scope :referral_challenges, -> { where(challenge_type: 'referral').where(is_approved: true) }

  ## Validations
  validates :challenge_type, :category, :name, :description, :image, :start, :timezone, :creator_id, :icon,
            :caption, presence: true
  validate :reward_existence
  validates_uniqueness_of :identifier, message: "already exists"

  # Get UTM params for this challenge
  def utm_parameters platform=nil
    #set the values
    utm_source = self.id.to_s rescue "unknown" #(36)
    if platform
      utm_medium = platform rescue "unknown"
    else
      utm_medium = self.parameters
    end
    utm_campaign = self.campaign.id.to_s rescue "unknown" # (36)
    return {
      utm_source:   utm_source,
      utm_medium:   utm_medium,
      utm_campaign: utm_campaign
    }
  end

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
      if !(self.challenge_type == 'engage') && (self.parameters == 'facebook')
        errors.add :reward_type, ' is invalid'
        return
      end
    end
  end

  ## Check Status of a Challenge [Draft, Active, Scheduled, Ended]
  def status
    if is_approved && (self.start.to_i - Time.now.in_time_zone(self.timezone).utc_offset) > Time.now.in_time_zone(self.timezone).to_i
      'scheduled'
    elsif is_approved && (self.finish.to_i - Time.now.in_time_zone(self.timezone).utc_offset) < Time.now.in_time_zone(self.timezone).to_i
      'ended'
    elsif is_approved
      'active'
    else
      'draft'
    end
  end

  ## Modify JSON Response
  def as_json(options = {})
    response = super.merge({
                               :status => status,
                               :reward_name => self.reward_type == 'prize' ? self.reward.name : ''
                           })

    if options.has_key?(:type) && options[:type] == 'one'
      ## Include Questions & It's Options in JSON Response
      question_list = questions.as_json(include_options: true)

      ## Encrypt in URI Format & Pass in URL
      crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials[Rails.env.to_sym][:encryption_key])
      encrypted_data = crypt.encrypt_and_sign("#{Participant.current.p_id}#{identifier}")
      encrypted_data = URI.encode_www_form_component(encrypted_data)
      challenge_url = "/participants/challenge/submit/#{encrypted_data}"

      response = response.merge({:questions => question_list, challenge_url: challenge_url})
    elsif options.has_key?(:type) && options[:type] == 'list'
      ## Remove Additional Details from JSON Response
      response.reject! {|k, v| %w"description content tag_list".include? k }
    end

    response
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
                " #{keyword} is_approved = true AND start <= timezone(timezone,now()) AND finish >= timezone(timezone,now())"

            ## Back up
            # status_query = status_query + " #{keyword} (is_approved = true AND start <= convert_tz('#{current_utc_time}', 'UTC', timezone) AND finish >= convert_tz('#{current_utc_time}', 'UTC', timezone))"
            # status_query = status_query + " #{keyword} (is_approved = true AND start <= convert_tz('#{current_utc_time}', 'UTC', timezone) AND finish >= convert_tz('#{current_utc_time}', 'UTC', timezone))"
          elsif val == 'scheduled'
            status_query = status_query +
                " #{keyword} is_approved = true AND start > timezone(timezone,now())"

            ## Back up
            # # status_query = status_query + " #{keyword} (is_approved = true AND start > convert_tz('#{current_utc_time}', 'UTC', timezone))"
            # #unix_timestamp(convert_tz(now(), 'UTC', offers.timezone))
            # status_query = " #{keyword} timezone(challenges.timezone, challenges.start) > :schedule"
            # ended_challenges = self.select{|challenge| challenge.finish.in_time_zone(challenge.timezone) < Time.now.in_time_zone(challenge.timezone)}
            # scheduled_keyword = Time.now.in_time_zone(self.timezone).to_i
          elsif val == 'ended'
            status_query = status_query +
                " #{keyword} is_approved = true AND finish < timezone(timezone,now())"

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
    self.campaign.participants.where('created_at < ?', self.finish.end_of_day).select { |x| x.eligible? self }
  end

  # Calculate Months For Insight User
  def calculate_months
    months = Challenge.all.map { |c| [c.start.strftime('%b'), c.finish.strftime('%b')] }
    months.flatten.uniq
  end

  ## Generate Unique Challenge Identifier
  def self.get_identifier
    new_id = SecureRandom.hex (6)
    p_id = self.where(identifier: new_id.downcase)
    if p_id.present?
      self.get_identifier
    else
      new_id.downcase
    end
  end

  ## Save Unique Challenge Identifier
  def generate_challenge_identifier
    self.update_attribute('identifier', Challenge.get_identifier)
  end
end
