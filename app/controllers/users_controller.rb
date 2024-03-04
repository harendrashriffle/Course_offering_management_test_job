class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:user_login]
  before_action :admin_access, only: [:create]
  before_action :user, only: [:update, :delete]

  def user_login
    if user = User.find_by(email: params[:email], password_digest: params[:password_digest])
      token = jwt_encode(user_id: user.id)
      render json: { message: "Logged In Successfully..", token: token }, status: :ok
    else
      render json: { error: "Please Check your Email And Password....." }, status: :unprocessable_entity
    end
  end

  def create
    user = User.new(set_params)
    return render json: {errors: user.errors.full_messages}, status: :unprocessable_entity unless user.save
    UserMailer.welcome_email(user).deliver_now
    render json: {message:"User Created", data: user}, status: :ok
  end

  def show
    return render json: user, status: :ok if admin
    render json: @current_user, status: :ok
  end

  def update
    return render json: {error: "User doesn't update"}, status: :unprocessable_entity unless user.update
    render json: user, status: :ok
  end

  def destroy
    return render json: {errors: "User doesn't delete succesfully"}, status: :unprocessable_entity unless user.destroy
    UserMailer.deletion_email(user).deliver_now
    render json: {message: "User Account delete Succesfully"}, status: :ok
  end

  private
    def set_params
      params.require(:user).permit(:name, :contact, :email, :password_digest, :type)
    end

    def user
      user = User.find_by_id(params[:id])
      user.nil? ? "User doesn't exist" : user
    end

    def admin
      @current_user.type == "Admin"
    end

    def instructor
      @current_user.type == "Instructor"
    end
end
