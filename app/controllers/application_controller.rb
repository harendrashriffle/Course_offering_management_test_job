class ApplicationController < ActionController::Base
  include JsonWebToken

  before_action :authenticate_request

  def authenticate_request
    begin
      header = request.headers[ 'Authorization' ]
      header = header.split(" ").last if header
      decoded = jwt_decode(header)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound
      render json: "No record found.."
    rescue JWT::DecodeError => e
      render json: { error: 'Invalid token' }, status: :unprocessable_entity
    end
  end

  def admin_access
    unless @current_user.type == "Admin"
      render json: {error: "You are not authorized for such action"}, status: :unprocessable_entity
    end
  end
end
