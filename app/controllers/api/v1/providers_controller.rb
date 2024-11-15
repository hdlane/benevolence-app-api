CLIENT_DOMAIN ||= Rails.application.credentials.client_domain

class Api::V1::ProvidersController < ApplicationController
  # GET /providers
  def index
    @providers = Provider.all

    render json: @providers
  end

  # GET /providers/1
  def show
    render json: @provider
  end

  # POST /providers
  def create
    @provider = Provider.new(provider_params)

    if @provider.save
      render json: @provider, status: :created, location: @provider
    else
      render json: @provider.errors, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /providers/1
  def update
    if @provider.update(provider_params)
      render json: @provider
    else
      render json: @provider.errors, status: :unprocessable_entity
    end
  end

  # DELETE /providers/1
  def destroy
    provider_id = params.require(:id)
    @provider = Provider.find(provider_id)
    resource_name = @provider.resource.name
    if session[:current_person_id] == @provider.person_id
      @provider.destroy!
      if @provider.destroyed?
        PersonMailer.with(
          person: @provider.person,
          request_link: "#{CLIENT_DOMAIN}/requests/#{@provider.resource.request.id}",
          resource_name: resource_name,
          title: @provider.resource.request.title
        ).provider_unassigned.deliver_later
      end
      render json: { message: "Provider unassigned successfully" }, status: :ok
    else
      render json: { errors: { message: "Forbidden", details: "You do not have permission to access this resource" } }, status: :forbidden
    end
  end

  private
    def provider_params
      params.require(:provider).permit(:person_id, :resource_id, :quantity)
    end
end
