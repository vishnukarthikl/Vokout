class OwnerMailer < ApplicationMailer
  default from: 'do-not-reply@vorkout.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.owner_mailer.password_reset.subject
  #
  def password_reset(owner)
    @owner = owner
    mail to: owner.email, subject: "Password Reset"

  end
end
