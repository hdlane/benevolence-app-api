class RequestsController < ApplicationController
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
    if @resource.update(resource_params)
      render json: @resource
    else
      render json: @resource.errors, status: :unprocessable_entity
    end
  end

  # DELETE /resources/1
  def destroy
    @resource.destroy!
  end

  private
    def resource_params
      params.require(:resource).permit(:request_id, :organization_id, :name, :kind, :quantity)
    end
end
