class Api::V1::SessionsController < ApplicationController
  before_action :find_person

  def create
    if @person
      # TODO: Redirect user to frontend homepage
      # Person ID already in unexpired cookies, pass through to homepage
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
    def find_person
      person_id = session[:current_person_id]
      @person = Person.find_by(id: person_id)
    end

    def login_link_creation(email, person)
      LoginLinkCreation.new(email, person)
    end
end
