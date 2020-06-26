class RewardMailer < ActionMailer::Base
  default from: 'systems@perksocial.com'
  layout 'mailer'

  def cash_in_reward(reward, participant, coupon)
    @reward = reward
    @participant = participant
    @coupon = coupon
    subject = "Congratulations you have just won a reward | #{@reward.name}"
    mail to: @participant.email, subject: subject
  end

  def milestone_reward_completion(reward, participant, coupon)
    @reward = reward
    @participant = participant
    @coupon = coupon
    subject = "Congratulations you have just won a reward | #{@reward.name}"
    mail to: @participant.email, subject: subject
  end

  def instant_reward(reward, participant, coupon)
    @reward = reward
    @participant = participant
    @coupon = coupon
    subject = "Congratulations you have just won a reward | #{@reward.name}"
    mail to: @participant.email, subject: subject
  end

  def manual_reward(reward, participant, coupon)
    @reward = reward
    @participant = participant
    @coupon = coupon
    subject = "Congratulations you have just won a reward | #{@reward.name}"
    mail to: @participant.email, subject: subject
  end

  def sweepstake_reward(reward, participant, coupon)
    @reward = reward
    @participant = participant
    @coupon = coupon
    subject = "Congratulations you have just won a reward | #{@reward.name}"
    mail to: @participant.email, subject: subject
  end

end
