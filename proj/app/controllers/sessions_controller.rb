class SessionsController < ApplicationController
  before_action :save_login_state, :only => [:login, :login_attempt]
  require "bundler/setup"
  require "pocketsphinx-ruby"
  require 'base64'
  require 'pry'
  require 'google/cloud/speech'
  def login
  end
  def login_attempt
    f = File.open("/home/yaron/git/password_recording/proj/output.txt", "r")
    name = f.read
    if name
      authorized_user = User.find_by username: name
      if authorized_user
        session[:user_id] = authorized_user.id
        flash[:notice] = "Wow Welcome again, you logged in as #{authorized_user.username}"
        redirect_to(:action => 'profile')
      else
        flash[:notice] = "Invalid Username or Password"
        flash[:color]= "invalid"
        render "login"
      end
    end
  end
  def home
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
           audio_path = "/home/yaron/git/password_recording/proj/public/" + "#{audio.original_filename}"
           cmd = "sox " + audio_path + " -c 1 temp1.wav"
           cur_path = `#{cmd}`
           cmd = "python lib/assets/python_script.py " + "/home/yaron/git/password_recording/proj/temp.wav"
           return_val = `#{cmd}`
           asd = return_val.split('>')[-1]
           rec_user = asd.split(' ')[-1]
           File.open("output.txt", 'w') do |f|
             f.write rec_user
           end
           #decoder = Pocketsphinx::Decoder.new(Pocketsphinx::Configuration.default)
           #decoder.decode '/home/yaron/git/password_recording/proj/public/' + "#{audio.original_filename}"
           #open('myfile.txt', 'w') do |f|
          #   f.puts decoder.hypothesis
           #end
          #session[:msg] = decoder.hypothesis
    end
  end
  def profile
    @current_user = User.find(session[:user_id])
  end
  def logout
  session[:user_id] = nil
  session[:rec_user] = nil
  redirect_to :action => 'login'
  end
  def setting
  end
end
