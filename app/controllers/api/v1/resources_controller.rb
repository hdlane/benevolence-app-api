class Api::V1::ResourcesController < ApplicationController
  # GET /resources
  def index
    @resources = Resource.all

    render json: @resources
  end

  # GET /resources/1
  def show
    render json: @resource
  end

  # POST /resources
  def create
    begin
      @resource = Resource.new(resource_params)

      if @resource.save
        render json: @resource, status: :created, location: @resource
      else
        render json: @resource.errors, status: :unprocessable_entity
      end
    rescue => e
        logger.error "Internal Server Error: #{e.message}"
        logger.error e.backtrace.join("\n")
    end
  end

  # PUT/PATCH /resources/1
  def update
    begin
      @resource = Resource.find(resource_params[:resource_id])
      resource = ResourceAssignment.new(@resource, resource_params, session)
      resource.assign_resource
      render json: { data: { resource: @resource }, message: "Resource assigned successfully" }, status: :ok
    rescue ResourceAssignment::ResourceAssignmentError => e
        logger.error "ResourceAssignmentError: #{e.message}"
        logger.error e.backtrace.join("\n")
        render json: { errors: { message: "Error saving resource", detail: "There was an error updating this resource" } }, status: :bad_request
    rescue => e
        logger.error "Internal Server Error: #{e.message}"
        logger.error e.backtrace.join("\n")
        render json: { errors: { message: "Internal Server Error", detail: "An error has occurred on the server" } }, status: :internal_server_error
    end
  end

  # DELETE /resources/1
  def destroy
    @resource = Request.find(params[:id])
    if session[:organization_id] == @resource.organization_id && session[:is_admin] == true
      @resource.destroy!
      render json: { message: "Resource deleted successfully" }, status: :ok
    else
      render json: { errors: { message: "Forbidden", details: "You do not have permission to access this resource" } }, status: :forbidden
    end
  end

  private
    def resource_params
      params.require(:resource_data).permit(:resource_id, :provider_id, :delivery_date_id, :name, :quantity)
    end
end
