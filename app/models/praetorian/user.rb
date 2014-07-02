# modules are good for creating buckets of related methods, mixins (a module that has methods that get mixed into other classes to follow DRY principle) and namespaces.

module Praetorian
  class User < ActiveRecord::Base
    has_secure_password
    validates :email, presence: true,
                      format: /\A\S+a\S+\z/,
                      uniqueness: { case_sensitive: false }
    validates_presence_of :password, :on => :create
    before_create { generate_token(:auth_token) }

    # Refactored to have 2 levels of authentication.  
    # Level 1. The user class level authenticate method to make sure e-mail exists for a user account.
    # Level 2. The instance level that is called on the user object that has_secure password provides to compare passwords.  User.authenticate is a convenience method that comes with has_secure_password.  It takes the plain text password passed in from the session form, encrypts it and compares to encrypted password_digest field in database.  If these two passwords match, authenticate returns the user object indicating the submitted password is correct.  If the passwords don't match, authenticate returns false indicating the password is incorrect.  Because the User.find_by above can return nil if there is no match, we must check if user and user.authenticate.
    # Note: params are at the controller level.  We can assign params values at the controller level and pass as arguments to other classes such as the User model.
   
    def self.authenticate(email, password)
      # user = User.find_by(email: params[:email]) - if performed in users_controller
        user = User.find_by(email: email)
      # if user && user.authenticate(params[:password]) - if performed in users_controller
        user && user.authenticate(password)
    end
  
    def admin?
      #
    end

    def send_password_reset
      generate_token(:password_reset_token)
      self.password_reset_sent_at = Time.zone.now
      save!
      UserMailer.password_reset(self).deliver
    end
  
    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end
  end
end