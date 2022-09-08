class OwnerMailer < ApplicationMailer
  default from: 'from@example.com'

  def owner_mail(email) 
    @email = email     
    mail to: @email, subject: "notice of changing an authority"
  end
end