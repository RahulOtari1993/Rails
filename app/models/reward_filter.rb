class RewardFilter < ApplicationRecord
	belongs_to :reward

	EVENTS = ["Age", "Tags", "Gender", "Points", "Rewards", "Platforms"]
	AGE_CONDITIONS = ["Equals", "Greater Than", "Less Than", "Greater Than or Equal", "Less Than or Equal"]
	SOCIAL_PLATFORMS = ["Facebook", "Twitter", "Google+", "Instagram", "Youtube" ]

	# serialize :reward_event, :reward_value, :reward_condition

	validates :reward_value, presence: true 
	validates :reward_event, presence: true, inclusion: EVENTS
	validates :reward_condition, presence: true, inclusion: AGE_CONDITIONS, if: Proc.new { |x| ["age", "points"].include?(x.reward_event) }
end
