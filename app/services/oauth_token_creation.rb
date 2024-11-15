require "oauth2"

# refresh token if it's within this many seconds
TOKEN_EXPIRATION_PADDING ||= 300

class OauthTokenCreation
  def get_authorize_url
    url = client.auth_code.authorize_url(
      scope: SCOPE,
      redirect_uri: "#{CLIENT_DOMAIN}/oauth" # "#{SERVER_DOMAIN}/oauth/complete"
    )
    url
  end

  def get_token(code: nil, organization: nil)
    if code
      token = client.auth_code.get_token(
        code,
        redirect_uri: "#{CLIENT_DOMAIN}/oauth"
      )
    elsif organization
      # check if token needs to refresh
      token_hash = {
        access_token: organization.access_token,
        refresh_token: organization.refresh_token,
        expires_at: organization.token_expires_at,
        token_type: "Bearer"
      }
      token = OAuth2::AccessToken.from_hash(client, token_hash)
      if (organization.token_expires_at < Time.now.to_i + TOKEN_EXPIRATION_PADDING) && organization.refresh_token
        token = token.refresh!
        organization.update!(
          access_token: token.token,
          refresh_token: token.refresh_token,
          token_expires_at: token.expires_at,
        )
      end
      organization.update!(synced_at: DateTime.now)
    end
    token
  end

  private
    def client
      OAuth2::Client.new(OAUTH_APP_ID, OAUTH_SECRET, site: API_URL)
    end
end
