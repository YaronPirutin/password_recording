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
    speech = Google::Cloud::Speech.new
    voice = speech.voice save_path,
                        encoding: :linear16,
                        language: "en-US",
                        sample_rate: 16000

    results = voice.recognize
    result = results.first
    File.open("textfromspeech", 'wb') do |f|
      f.write result.transcript
    end

      flash[:notice] = save_path
    else
      redirect_to(:controller => 'sessions', :action => 'home')
    end
  end
  private
  def user_params
    params.require(:user).permit(:username)
  end
end
