class RewardMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def cash_in_reward(reward, participant, coupon)
    @reward = reward
    @participant = participant
    @coupon = coupon
    subject = "You have won Cash In Reward Coupon "
    mail to: @participant.email, subject: subject
  end

end
