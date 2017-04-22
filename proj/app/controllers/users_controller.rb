class UsersController < ApplicationController
  require "bundler/setup"
  require "pocketsphinx-ruby"
  require 'base64'
  include Pocketsphinx
  before_action :save_login_state, :only => [:new, :create]
  def new
    @user = User.new
  end
  def create
    audio = params[:url]
    save_path = Rails.root.join("public/asd1.wav")
      # Open and write the file to file system.
    File.open(save_path, 'wb') do |f|
      f.write audio.read
    end
    flash[:notice] = "You signed up successfully, you recorded "
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "You signed up successfully "
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
  def save_file
    audio = params[:url]
    save_path = Rails.root.join("public/asd1.wav")
    File.open(save_path, 'wb') do |f|
      f.write audio.read
    end
  end
  private
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
