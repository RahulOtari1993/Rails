# == Schema Information
#
# Table name: reward_participants
#
#  id             :bigint           not null, primary key
#  reward_id      :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  participant_id :integer
#
class RewardParticipant < ApplicationRecord

  belongs_to :reward
  belongs_to :participant
  has_one :coupon, dependent: :destroy

  ## Callbacks
  after_create :reward_claims_change

  private

  ## Increase Rewards Claims Counter
  def reward_claims_change
    reward = self.reward
    count = reward.claims + 1
    reward.update_attribute(:claims, count)
  end

  # after_create do |current|
	# #we have created the relationship...if there are coupons lets bind one if its available
	# if current.reward.coupons.where(reward_participant_id: nil).count > 0
	# 	#we have an available coupon
	# 	coupon = current.reward.coupons.where(reward_participant_id: nil).first
	# 	#now that we have a coupon bind
	# 	coupon.reward_participant = self
	# 	#persist the change
	# 	coupon.save
	# end
	# #now that we have a fully bound item fire off an email
	# Mailman.award(self).deliver
  # end
end
