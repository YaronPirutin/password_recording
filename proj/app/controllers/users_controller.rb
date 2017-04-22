class UsersController < ApplicationController
  before_action :save_login_state, :only => [:new, :create]
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "You signed up successfully"
      flash[:color]= "valid"
      session[:user_id] = @user.id
      redirect_to(:controller => 'sessions', :action => 'profile')
      return
    else
      flash[:notice] = "Form is invalid"
      flash[:color]= "invalid"
    end
      render "new"
      return
  end
  private
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
