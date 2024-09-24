class CoordinatorsController < ApplicationController
  # GET /coordinators
  def index
    @coordinators = Coordinator.all

    render json: @coordinators
  end

  # GET /coordinators/1
  def show
    render json: @coordinator
  end

  # POST /coordinators
  def create
    @coordinator = Coordinator.new(coordinator_params)

    if @coordinator.save
      render json: @coordinator, status: :created, location: @coordinator
    else
      render json: @coordinator.errors, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /coordinators/1
  def update
    if @coordinator.update(coordinator_params)
      render json: @coordinator
    else
      render json: @coordinator.errors, status: :unprocessable_entity
    end
  end

  # DELETE /coordinators/1
  def destroy
    @coordinator.destroy!
  end

  private
    def coordinator_params
      params.require(:coordinator).permit(:person_id, :request_id)
    end
end
