# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# SendGrid email configuration
ActionMailer::Base.smtp_settings = {
  user_name: "apikey",
  password: Rails.application.credentials.sendgrid_api_key,
  domain: "benevolenceapp.com",
  address: "smtp.sendgrid.net",
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}
