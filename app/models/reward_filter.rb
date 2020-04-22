# == Schema Information
#
# Table name: reward_filters
#
#  id               :bigint           not null, primary key
#  reward_id        :bigint
#  reward_condition :string
#  reward_value     :string
#  reward_event     :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class RewardFilter < ApplicationRecord
	belongs_to :reward

	EVENTS = %w(age tags gender points rewards challenges platforms)
  	CONDITIONS = %w(equals greater_than less_than greater_than_or_equal less_than_or_Equal)
  	SOCIAL_PLATFORMS = %w(facebook twitter google instagram youtube)
	# serialize :reward_event, :reward_value, :reward_condition

	validates :reward_value, presence: true 
	validates :reward_event, presence: true, inclusion: RewardFilter::EVENTS
	validates :reward_condition, presence: true, inclusion: RewardFilter::CONDITIONS, if: Proc.new { |x| ["age", "points"].include?(x.reward_event) }
end
