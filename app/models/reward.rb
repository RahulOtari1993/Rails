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
#  filter_type         :integer          default("all_filters")
#  filter_applied      :boolean          default(FALSE)
#  rule_type           :integer          default("all_rules")
#  rule_applied        :boolean          default(FALSE)
#  claims              :integer          default(0)
#  date_range          :boolean          default(FALSE)
#
class Reward < ApplicationRecord

  ## Associations
  belongs_to :campaign
  has_many :coupons
  has_many :reward_filters, inverse_of: :reward

  has_many :reward_participants, dependent: :destroy
  # has_many :users, through: :reward_participants
  has_many :participants, through: :reward_participants
  has_many :coupons, :dependent => :delete_all
  has_many :reward_rules, :dependent => :delete_all
  has_one_attached :image
  # has_one_attached :image_actual
  # has_one_attached :photo_image
  # has_one_attached :thumb_image

  ## ENUM
  enum filter_type: {all_filters: 0, any_filter: 1}
  enum rule_type: {all_rules: 0, any_rule: 1}, _prefix: :rule
  serialize :image

  accepts_nested_attributes_for :reward_filters, allow_destroy: true, :reject_if => :all_blank
  accepts_nested_attributes_for :reward_rules, allow_destroy: true, :reject_if => :all_blank

  ## Tags
  acts_as_taggable_on :tags

  ## Image Uploader
  mount_uploader :image, ImageUploader

  ## Constants
  SELECTIONS = %w[manual redeem instant threshold selection sweepstake milestone]
  FULFILMENTS = %w[default badge points download]

  ## Scopes
  scope :active, -> { where("finish > ?", Time.zone.now) }

  validates :campaign, presence: true
  validates :name, presence: true
  validates :threshold, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}, if: Proc.new { |x| x.selection == "selection" }
  validates :selection, presence: true, inclusion: SELECTIONS
  # validates :fulfilment, presence: true, inclusion: FULFILMENTS
  validates :description, presence: true
  validates :image, presence: true

  # Scopes
  scope :featured, -> { where(arel_table[:feature].eq(true)) }
  scope :current_active, -> (date = Time.now) { where(arel_table[:start].lteq(date).and(arel_table[:finish].gteq(date))) }

  ## Check Status of a Challenge [Draft, Active, Scheduled, Ended]
  def status
    if self.start.in_time_zone('UTC') > Time.now.in_time_zone('UTC')
      'scheduled'
    elsif self.finish.in_time_zone('UTC') < Time.now.in_time_zone('UTC')
      'ended'
    elsif self.start.in_time_zone('UTC') < Time.now.in_time_zone('UTC') && self.finish.in_time_zone('UTC') > Time.now.in_time_zone('UTC')
      'active'
    else
    end
  end

  ##for adding status column to datatable json response
  def as_json(*)
    super.tap do |hash|
      hash["status"] = status
    end
  end

  ## Rewards Filters
  def self.reward_side_bar_filter(filters)
    query = 'id IS NOT NULL'
    status_query_string = ''
    tags_query = ''
    filters.each do |key, value|
      if key == 'status' && value.present?
        active_start_date = Time.now
        active_end_date = Time.now

        status_sub_query = ' AND ('
        value.each_with_index do |status, index|
          if (index == 0)
            if status == 'active'
              status_sub_query = status_sub_query + " start <= '#{active_start_date}' AND finish >= '#{active_end_date}'"
            elsif status == 'scheduled'
              status_sub_query = status_sub_query + " start >= '#{active_end_date}'"
            else
              status_sub_query = status_sub_query + "finish <= '#{active_end_date}'"
            end
          else
            if status == 'active'
              status_sub_query = status_sub_query + " OR start <= '#{active_start_date}' AND finish >= '#{active_end_date}'"
            elsif status == 'scheduled'
              status_sub_query = status_sub_query + " OR start >= '#{active_end_date}'"
            else
              status_sub_query = status_sub_query + " OR finish <= '#{active_end_date}'"
            end
          end
        end
        status_sub_query = status_sub_query + ')'

        status_query_string = status_sub_query
      elsif key == 'tags' && filters[key].present?
        filters[key].each do |tag|
          tags_query = tags_query + " AND EXISTS (SELECT * FROM taggings WHERE taggings.taggable_id = rewards.id AND taggings.taggable_type = 'Reward'" +
              " AND taggings.tag_id IN (SELECT tags.id FROM tags WHERE (LOWER(tags.name) ILIKE '#{tag}' ESCAPE '!')))"
        end
      end
    end
    final_query = query + status_query_string + tags_query

    return final_query
  end

  ## Check if Reward is Available for Participant
  def available?
    ## Set Result, By Default it is TRUE
    result = true
    result_array = []

    # Loop Through the Filters
    self.reward_filters.each do |filter|
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

  ## Check if Participant is Eligible for Reward
  def eligible? participant
    ## Set Result, By Default it is TRUE
    result = true
    result_array = []

    # Loop Through the Rules
    self.reward_rules.each do |rule|
      result_array.push(rule.eligible? participant)
    end

    ## Check If We need to Include ALL/ANY Rules
    if self.rule_type == 'all_rules'
      result = !result_array.include?(false)
    else
      result = result_array.include?(true)
    end

    result
  end
end
