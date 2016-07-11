class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(username: session_params[:username])
    if @user && @user.authenticate(session_params[:password])
      session[:user_id] = @user.id
      # redirect_to root_path
    else
      flash["alert"] = "Login failed."
      render :new
    end
  end

  def destroy
    
  end

  private
  def session_params
    params.require(:user).permit(:username, :password)
  end
end
