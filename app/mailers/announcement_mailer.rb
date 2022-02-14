class AnnouncementMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.announcement_mailer.announcement_created.subject
  #
  def announcement_created
    @greeting = "Hi"

    mail to: Player.all.pluck(:email)
  end
end
