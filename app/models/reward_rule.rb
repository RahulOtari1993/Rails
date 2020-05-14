# == Schema Information
#
# Table name: reward_rules
#
#  id         :bigint           not null, primary key
#  type       :string
#  reward_id  :bigint
#  condition  :string
#  value      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class RewardRule < ApplicationRecord
  belongs_to :reward
  RULES = [
		"challenges_completed",
		"number_of_logins"    ,
		"points"              ,
		"recruits"            
	]
	CONDITIONS = %w(equals greater_than less_than greater_than_or_equal less_than_or_Equal)
end
