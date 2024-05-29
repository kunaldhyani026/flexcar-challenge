class ApplicationController < ActionController::API
  before_action :authenticate_user

  private

  def authenticate_user
    render_error('unauthorized_user', 'invalid user_id ', 401) unless params[:user_id].present?
  end

  def render_error(type, message, http_status_code)
    render json: { error: { type:, message:} }, status: http_status_code
  end

  def render_response(response)
    render json: response['body'], status: response['status']
  end
end
