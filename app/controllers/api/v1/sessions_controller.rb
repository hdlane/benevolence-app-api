class Api::V1::SessionsController < ApplicationController
  before_action :find_person

  def login
    email = params[:email]
    @person = Person.find_by(email: email)
    if @person
      token = @person.to_sgid.to_s
      LoginLinkService.create_login_link(email: email, token: token)
    else
      render json: {errors: {status: 404, title: "Not Found", detail: "The resource you requested could not be found"}}
    end
  end

  def logout
  end

  private
    def find_person
      user_id = session[:current_user_id]
      @current_user = Person.find_by(id: user_id)
    end
end
