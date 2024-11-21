<p align="center">
  <img loading="lazy" alt="Benevolence App" src="https://github.com/user-attachments/assets/ef388283-4b4d-41a5-83fb-079928fe3e06" />
</p>

# Benevolence App API

The backend API for the Benevolence App built in Ruby on Rails. The Benevolence App is a solution that integrates with Planning Center to provide meals, services, and item donations to those in need. It was developed in response to the lack of a built-in solution within Planning Center. This repository handles all data processing, syncing, and API endpoints.

View the app here: [https://app.benevolenceapp.com/](https://app.benevolenceapp.com)

View videos of the app in action here: [https://github.com/hdlane/benevolence-app-demo](https://github.com/hdlane/benevolence-app-demo)

## Features
- Exposes endpoints for managing requests, resources, and users.
- Integrates with Planning Center for data synchronization.
- Handles authentication using login links and session management.

## Getting Started
1. Clone this repository:
   ```bash
   git clone https://github.com/hdlane/benevolence-app-api.git
2. Navigate to the directory:
   ```bash
   cd benevolence-app-api
3. Install dependencies:
   ```bash
   bundle install
4. Setup the database:
   ```bash
   rails db:setup
5. Start the server:
   ```bash
   rails s
6. The API will be available at `http://localhost:3000/api/v1`

## Dependencies
- Ruby 3.x
- Rails 7.x
- SQLite (Development) / PostgreSQL (Production)
- [Planning Center API integration](https://developer.planning.center/docs/#/overview)
- [SendGrid](https://sendgrid.com) for sending emails
- [pco_api](https://github.com/planningcenter/pco_api_ruby) for Planning Center API operations
- [oauth2](https://github.com/oauth-xx/oauth2) for OAuth tokens with Planning Center

## Usage
- Pair this API with the [Benevolence App Client](https://github.com/hdlane/benevolence-app-client).
- Update your development.yaml.enc credentials (found under `/config/credentials`
  ```bash
  rails credentials:edit --environment development
  # Rails Key
  secret_key_base: ...
  # Sendgrid API
  sendgrid_api_key: ...
  # Planning Center API
  oauth_app_id: ...
  oauth_secret: ...
  scope: people
  api_url: https://api.planningcenteronline.com
  # URLs used by Rails as constants
  server_domain: http://localhost:3000/api/v1
  client_domain: http://localhost:5173
  active_record_encryption:
    primary_key: ...
    deterministic_key: ...
    key_derivation_salt: ...
- Update your production.yaml.enc credentials as well
  ```bash
  rails credentials:edit --environment production
  # Rails Key
  secret_key_base: ...
  # Sendgrid API
  sendgrid_api_key: ...
  # Planning Center API
  oauth_app_id: ...
  oauth_secret: ...
  scope: people
  api_url: https://api.planningcenteronline.com
  # URLs used by Rails as constants
  server_domain: yourserver.com
  client_domain: yourclient.com
  active_record_encryption:
    primary_key: ...
    deterministic_key: ...
    key_derivation_salt: ...
- When initiating emails in development, the mail configuration does not use Sendgrid. Instead the contents on the email will be in the Rails console logs for you to use. If you want to use Sendgrid, edit the `/config/environments/development.rb` file:
  ```ruby
  # SendGrid email configuration
  ActionMailer::Base.smtp_settings = {
    user_name: "apikey",
    password: Rails.application.credentials.sendgrid_api_key,
    domain: "yourdomain.com",
    address: "smtp.sendgrid.net",
    port: 587,
    authentication: :plain,
    enable_starttls_auto: true
  }

## License
This project is licensed under the MIT License.
