class ApplicationController < ActionController::API
  before_action :authenticate_user

  private

  # authenticates user before every controller action
  # For simplicity, currently only check is to see if user_id is present in payload/headers or not.
  # In production systems, user_id should be decoded from the auth token and
  # then user_id should be used ahead for maintaining user's cart states.
  def authenticate_user
    render_error('unauthorized_user', 'invalid user_id', 401) unless params[:user_id].present?
  end

  # Method to render_error to be used across different controllers
  def render_error(type, message, http_status_code)
    render json: { error: { type:, message:} }, status: http_status_code
  end

  # Method to render_response to be used across different controllers
  def render_response(response)
    render json: response['body'], status: response['status']
  end
end
