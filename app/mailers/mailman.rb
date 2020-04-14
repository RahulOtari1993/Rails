class Mailman < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def award(reward_contact)
    @reward_contact = reward_contact
 	
    mail to: @reward_contact.user.email, subject: "Congratulations you have just won a reward | #{@reward_contact.reward.campaign.name}", from: "support@buckeyenationrewards.com"
  end

end