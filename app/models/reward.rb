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

  enum filter_type: {all_filters: 0, any_filter: 1}
  serialize :image
  validates :image, presence: true

  accepts_nested_attributes_for :reward_filters, allow_destroy: true, :reject_if => :all_blank
  accepts_nested_attributes_for :reward_rules, allow_destroy: true, :reject_if => :all_blank

  ## Tags
  acts_as_taggable_on :tags

  mount_uploader :image, ImageUploader

  SELECTIONS = [
      "manual",
      "redeem",
      "instant",
      "threshold",
      "selection",
      "sweepstake",
      "milestone_reward"
  ]

  FULFILMENTS = [
      "default",
      "badge",
      "points",
      "download"
  ]


  validates :campaign, presence: true
  validates :name, presence: true
  validates :threshold, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 0}, if: Proc.new { |x| x.selection == "selection" }
  validates :selection, presence: true, inclusion: SELECTIONS
  # validates :fulfilment, presence: true, inclusion: FULFILMENTS
  validates :description, presence: true

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

  ##challenge platform filter
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
        # value.each do |val|
        #   if val == 'active'
        #     status_query_string = status_query_string + ' AND start < (:active_start_date) AND finish > (:active_end_date)'
        #     active_start_date = Time.now
        #     active_end_date = Time.now
        #   elsif val == 'scheduled'
        #     status_query_string = status_query_string + ' AND start > (:scheduled_date)'
        #     scheduled_date = Time.now
        #     # elsif value == 'ended'
        #     #  start_time = Time.now.in_time_zone(@time_zone).to_i
        #     #  = " AND rewards.start + (unix_timestamp() -  unix_timestamp(convert_tz(now(), 'UTC', rewards.timezone))) >= :start_time"
        #     # ended_rewards = self.select{|challenge| challenge.finish.in_time_zone(challenge.timezone) < Time.now.in_time_zone(challenge.timezone)}
        #   else
        #     status_query_string = status_query_string + ' AND finish < (:ended_date)'
        #     ended_date = Time.now
        #   end
        # end
        # elsif key == 'challenge_type' && filters[key].present?
        #   type_query_string = ' AND challenge_type IN (:challenge_type)'
        #   challenge_type << value
        # elsif key == 'platform_type' && filters[key].present?
        #   if Challenge.parameters.values_at(*Array(value)).present?
        #     platform_query_string = ' AND parameters IN (:parameters)'
        #     parameters << value
        #   end
      elsif key == 'tags' && filters[key].present?
        filters[key].each do |tag|
          tags_query = tags_query + " AND EXISTS (SELECT * FROM taggings WHERE taggings.taggable_id = rewards.id AND taggings.taggable_type = 'Reward'" +
              " AND taggings.tag_id IN (SELECT tags.id FROM tags WHERE (LOWER(tags.name) ILIKE '#{tag}' ESCAPE '!')))"
        end
      end
    end
    final_query = query + status_query_string + tags_query
    rewards = self.where(final_query)

    return rewards
  end
end
