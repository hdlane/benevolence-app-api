require "oauth2"
require "pco_api"

OAUTH_APP_ID = Rails.application.credentials.oauth_app_id
OAUTH_SECRET = Rails.application.credentials.oauth_secret
SCOPE = Rails.application.credentials.scope
API_URL = Rails.application.credentials.api_url
DOMAIN = Rails.application.credentials.domain

class Api::V1::IntegrationsController < ApplicationController
  def oauth
    url = client.auth_code.authorize_url(
      scope: SCOPE,
      redirect_uri: "#{DOMAIN}/oauth/complete"
    )
    redirect_to(url, allow_other_host: true)
  end

  def oauth_complete
    token = client.auth_code.get_token(
      params[:code],
      redirect_uri: "#{DOMAIN}/oauth/complete"
    )
    render json: { token: token }
    # TODO: How do I get the token from here to a secure cookie
    # then redirect_to "http://localhost:5173"
  end

  def sync
    # TODO:
    # * Gather info from PCO to create Person - make a class?
    # * Create / Update each person from PCO into People table

    token = params[:token]
    response = api(token).people.v2.people.get
    people = response["data"]
    people.each do |person|
      id = person["id"]
      person = person["attributes"]
    end
    render json: { data: people }
  end

  private
    def client
      OAuth2::Client.new(OAUTH_APP_ID, OAUTH_SECRET, site: API_URL)
    end

    def token
    end

    def api(token)
      PCO::API.new(url: API_URL, oauth_access_token: token)
    end
end
