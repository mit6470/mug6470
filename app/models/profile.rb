# Profile of the user.
class Profile < ActiveRecord::Base
  belongs_to :user, :inverse_of => :profile
  validates :user, :presence => true
  validates :user_id, :uniqueness => true
  attr_protected :user_id
  
  # Trials created by this user profile.
  has_many :projects, :dependent => :destroy, :inverse_of => :profile
  
  has_many :data, :dependent => :destroy, :inverse_of => :profile
end
