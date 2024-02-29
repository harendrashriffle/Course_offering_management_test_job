class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:user_login]

  def user_login
    if user = User.find_by(email: params[:email], password_digest: params[:password_digest])
      token = jwt_encode(user_id: user.id)
      render json: { message: "Logged In Successfully..", token: token }
    else
      render json: { error: "Please Check your Email And Password....." }
    end
  end

  def create
    if @current_user.type == "Admin"
      user = User.new(set_params)
      return render json: {errors: user.errors.full_messages} unless user.save
      render json: {message:"User Created", data: user}
    else
      render json: {message: "You are not authorized to create account"}
    end
  end

  def show
    if @current_user.type == "Admin"
      user = User.find_by_id(params[:id])
      if user.present?
        render json: {message:"Here is your result", data: user}
      else
        render json: {error: "Id is not present"}
      end
    else
      render json: @current_user
    end
  end

  private
    def set_params
      params.permit(:name, :contact, :email, :password_digest, :type)
    end
end
