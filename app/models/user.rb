# An user account.
class User < ActiveRecord::Base
  include Authpwn::UserModel

  # Virtual email attribute, with validation.
  include Authpwn::UserExtensions::EmailField
  # Virtual password attribute, with confirmation validation.
  include Authpwn::UserExtensions::PasswordField
  # Convenience Facebook accessors.
  # include Authpwn::UserExtensions::FacebookFields


  # Add your extensions to the User class here.
  has_one :profile, :dependent => :destroy, :inverse_of => :user
  
  has_many :projects, :through => :profile
end
