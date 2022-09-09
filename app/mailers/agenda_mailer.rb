class AgendaMailer < ApplicationMailer
  default from: 'from@example.com'

  def agenda_delete_mail(email) 
    @email = email 
    mail to: @email, subject: "Agenda assosiated with you was deleted now."
  end
end