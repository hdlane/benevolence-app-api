require "oauth2"

OAUTH_APP_ID ||= Rails.application.credentials.oauth_app_id
OAUTH_SECRET ||= Rails.application.credentials.oauth_secret
API_URL ||= Rails.application.credentials.api_url
SCOPE ||= Rails.application.credentials.scope
SERVER_DOMAIN ||= Rails.application.credentials.server_domain

class OauthTokenCreation
  def get_authorize_url
    url = client.auth_code.authorize_url(
      scope: SCOPE,
      redirect_uri: "#{SERVER_DOMAIN}/oauth/complete"
    )
    url
  end

  def get_token(code = nil)
    if code
      token = client.auth_code.get_token(
        code,
        redirect_uri: "#{SERVER_DOMAIN}/oauth/complete"
      )
    else
      puts "NO CODE SUPPLIED - GET TOKEN FROM ORGANIZATION"
    end
    token
  end

  private
    def client
      OAuth2::Client.new(OAUTH_APP_ID, OAUTH_SECRET, site: API_URL)
    end
end
