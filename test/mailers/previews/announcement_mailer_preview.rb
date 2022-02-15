# Preview all emails at http://localhost:3000/rails/mailers/announcement_mailer
class AnnouncementMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/announcement_mailer/announcement_created
  def announcement_created
    AnnouncementMailer.announcement_created
  end

end
