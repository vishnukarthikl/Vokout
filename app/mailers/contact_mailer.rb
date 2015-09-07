class ContactMailer < ApplicationMailer

  default from: 'do-not-reply@vorkout.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.enquiry.subject
  #
  def enquiry(contact_message)
    @contact_message = contact_message
    mail to: ["vishnucarbon@gmail.com","prashannaguru.r@gmail.com"],subject: "[Vorkout]New contact message"
  end
end
