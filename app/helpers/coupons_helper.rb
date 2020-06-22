module CouponsHelper

  ## Get email of Coupon Holder
  def coupon_holder_email coupon
    coupon.reward_participant_id.present? ? coupon.reward_participant.participant.email : ''
  end
end
