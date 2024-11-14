class ApplicationMailer < ActionMailer::Base
  default from: ActionMailer::Base.email_address_with_name("notifications@benevolenceapp.com", "Benevolence App")
  layout "mailer"
end
