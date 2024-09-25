class PersonMailer < ApplicationMailer
  def mail_login_link
    @person = params[:person]
    @url = params[:url]
    mail(to: @person.email, subject: "Login to Benevolence App")
  end
end
