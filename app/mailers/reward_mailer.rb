class RewardMailer < ActionMailer::Base
  default from: 'systems@perksocial.com'
  layout 'mailer'

  def cash_in_reward(reward, participant, coupon)
    @reward = reward
    @participant = participant
    @coupon = coupon
    subject = "You have won Cash In Reward Coupon "
    mail to: @participant.email, subject: subject
  end

end
