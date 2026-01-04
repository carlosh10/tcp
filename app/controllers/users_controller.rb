class UsersController < ApplicationController
  def new
    @user = User.new
    redirect_to dashboard_path if logged_in?
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to dashboard_path, notice: "Account created successfully! Welcome!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :home_country_code, :timezone)
  end
end
