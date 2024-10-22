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
    @resource = Resource.new(resource_params)

    if @resource.save
      render json: @resource, status: :created, location: @resource
    else
      render json: @resource.errors, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /resources/1
  def update
    begin
      resource = ResourceAssignment.new(@resource, resource_params, session)
      resource.assign_resource
      render json: { data: { resource: @resource }, message: "Resource assigned successfully" }, status: :ok
    rescue ResourceAssignment::ResourceAssignmentError => e
          render json: { errors: { message: "Error saving resource", detail: e.message } }, status: :bad_request
    rescue => e
          render json: { errors: { message: "Internal Server Error", detail: e.message } }, status: :internal_server_error
    end
  end

  # DELETE /resources/1
  def destroy
    @resource = Request.find(params[:id])
    if session[:organization_id] == @resource.organization_id && session[:is_admin] == true
      @resource.destroy!
    else
      render json: { errors: { message: "Forbidden", details: "You do not have permission to access this resource" } }, status: :forbidden
    end
  end

  private
    def resource_params
      params.require(:resource).permit(:request_id, :organization_id, :name, :kind, :quantity, :assigned)
    end
end
