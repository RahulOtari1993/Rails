# Preview all emails at http://localhost:3000/rails/mailers/sport_mailer
class SportMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/sport_mailer/sport_created
  def sport_created
    SportMailer.sport_created
  end

end
