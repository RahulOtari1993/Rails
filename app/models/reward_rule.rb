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
