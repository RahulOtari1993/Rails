class SportMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.sport_mailer.sport_created.subject
  #
  def sport_created
    @greeting = "Hi"

    mail to: Player.first.email, cc: Player.all.pluck(:email)
  end
end
