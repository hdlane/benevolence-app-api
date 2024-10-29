class RequestUpdate
  # take request data from client that contains
  # request changes and resource changes, and
  # update appropriately
  def initialize(request, params, session)
    @request = request
    @request_data = params[:request]
    @resources_data = params[:resources]
    @user_id = session[:current_person_id]
  end
end
