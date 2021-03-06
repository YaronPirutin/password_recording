class UsersController < ApplicationController
  require "bundler/setup"
  require "pocketsphinx-ruby"
  require 'base64'
  require 'pry'
  require 'google/cloud/speech'
  include Pocketsphinx
  before_action :save_login_state, :only => [:new, :create]
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "You signed up successfully "
      flash[:color]= "valid"
      session[:user_id] = @user.id
      redirect_to(:controller => 'users', :action => 'new_record')
      return
    else
      flash[:notice] = "Form is invalid"
      flash[:color]= "invalid"
    end
      render "new"
      return
  end
  def new_record
    @user = User.find(session[:user_id])
  end
  def save_file
    audio = params[:sound]
    if audio
          save_path = Rails.root.join("public/#{audio.original_filename}")
          audio.rewind
           # Open and write the file to file system.
           File.open(save_path, 'wb') do |f|
             f.write audio.read
           end
           session[:path] = "#{audio.original_filename}"
    else
      redirect_to(:controller => 'sessions', :action => 'home')
    end
  end
  def finish_record
    user = User.find(params[:uid])
    audio_name = session[:path]
    cmd = "echo $PWD"
    cur_path = `#{cmd}`
    cur_path.slice! "/app/controllers"
    audio_path = "/home/yaron/git/password_recording/proj/public/" + audio_name
    cmd = "sox " + audio_path + " -c 1 temp.wav"
    cur_path = `#{cmd}`
    cmd = "python lib/assets/python_script.py 1 " + "/home/yaron/git/password_recording/proj/temp.wav" + " " + user.username
    return_val = `#{cmd}`
    File.open("sas.txt", 'w') do |f|
      f.write return_val
    end

    cmd = "rm home/yaron/git/password_recording/proj/temp.wav"
    return_val = `#{cmd}`
    redirect_to(:controller => 'sessions', :action => 'home')
  end
  private
  def user_params
    params.require(:user).permit(:username)
  end
end
