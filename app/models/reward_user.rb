class RewardUser < ApplicationRecord
  belongs_to :user
  belongs_to :reward
  has_one :coupon, dependent: :destroy

  after_create do |current|
	#we have created the relationship...if there are coupons lets bind one if its available
	if current.reward.coupons.where(reward_user_id: nil).count > 0
		#we have an available coupon
		coupon = current.reward.coupons.where(reward_user_id: nil).first
		#now that we have a coupon bind
		coupon.reward_user = self
		#persist the change
		coupon.save
	end
	#now that we have a fully bound item fire off an email
	Mailman.award(self).deliver
  end
end
