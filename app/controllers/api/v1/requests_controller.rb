class Api::V1::RequestsController < ApplicationController
  before_action :find_person_logged_in

  # GET /requests
  def index
    if @person_logged_in
      @organization_id = session[:organization_id]
      @requests = Request.where(organization_id: @organization_id)
      render json: @requests
    else
      render json: { errors: { status: 403, title: "Unauthorized", detail: "You do not have permission to access this resource" } }, status: 403
    end
  end

  # GET /requests/1
  def show
    render json: @request
  end

  # POST /requests
  def create
    @request = Request.new(request_params)

    if @request.save
      render json: @request, status: :created, location: @request
    else
      render json: @request.errors, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /requests/1
  def update
    if @request.update(request_params)
      render json: @request
    else
      render json: @request.errors, status: :unprocessable_entity
    end
  end

  # DELETE /requests/1
  def destroy
    @request.destroy!
  end

  private
    def request_params
      params.require(:request).permit(:person_id, :organization_id, :type, :title, :notes, :allergies, :start_date,
                                      :start_time, :end_date, :end_time, :street_line, :city, :state, :zip_code)
    end
end
