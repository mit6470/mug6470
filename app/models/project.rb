class Project < ActiveRecord::Base
  belongs_to :profile, :inverse_of => :projects
  validates :profile, :presence => true
  attr_protected :profile
  
  has_many :trials, :inverse_of => :project, :dependent => :destroy
  
  # Name of the project.
  validates :name, :presence => true, :length => 1..64 

  # Returns the maximum trial number in this project.
  def max_trial_number
    trials.maximum(:number) || 0
  end
end
