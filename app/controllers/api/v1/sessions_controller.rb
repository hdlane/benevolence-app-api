CLIENT_DOMAIN ||= Rails.application.credentials.client_domain

class Api::V1::SessionsController < ApplicationController
  skip_before_action :require_login
  before_action :find_person_logged_in

  def create
    if @person_logged_in
      redirect_to ("#{CLIENT_DOMAIN}/")
    else
      email = params[:email]
      @person = Person.find_by(email: email)
      if @person
        login_link_creation(email, @person).create_login_link
      else
        render json: { errors: { status: 404, title: "Not Found", detail: "The resource you requested could not be found" } }, status: 404
      end
    end
  end

  def verify
    # TODO:
    # after token verification, check if Person email exists for other
    # Organizations and then other Organization People:
    #
    # Flow:
    # token exists and person matches to token
    # if email exists in multiple Organizations, prompt to select one
    # then if email exists for multiple People, prompt to select one
    # then create session
    begin
      token = params.require(:token)
      person = GlobalID::Locator.locate_signed(token)

      if person && person.is_a?(Person)
        session[:current_person_id] = person.id
        session[:name] = person.name
        session[:organization_id] = person.organization_id
        session[:is_admin] = person.is_admin

        # render json: { status: :created, logged_in: true }
        redirect_to ("#{CLIENT_DOMAIN}/")
      else
        render json: { errors: { status: 404, title: "Not Found", detail: "The resource you requested could not be found" } }, status: 404
      end
    rescue ActionController::ParameterMissing => e
      render json: { errors: { status: 400, title: "Bad Request", detail: "#{e.message}" } }, status: 400
    end
  end

  def destroy
    reset_session
  end

  private
    def login_link_creation(email, person)
      LoginLinkCreation.new(email, person)
    end
end
