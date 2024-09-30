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
        render json: { errors: { status: 404, title: "Not Found", detail: "The resource you requested could not be found" } }
      end
    end
  end

  def verify
    token = params.require(:token)
    person = GlobalID::Locator.locate_signed(token)

    if person && person.is_a?(Person)
      session[:current_person_id] = person.id
      session[:name] = person.name
      session[:organization_id] = person.organization_id
      session[:is_admin] = person.is_admin

      render json: { status: :created, logged_in: true }
    else
        render json: { errors: { status: 404, title: "Not Found", detail: "The resource you requested could not be found" } }
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
