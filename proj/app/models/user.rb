class User < ActiveRecord::Base
  attr_accessor :password

  before_save :encrypt_password
  after_save :clear_password

  validates :username, :presence => true, :length => { :in => 3..20 }


  def match_password(login_password="")
    encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
  end



  def encrypt_password
    unless password.blank?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def clear_password
    self.password = nil
  end
end
