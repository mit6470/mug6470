class Project < ActiveRecord::Base
  belongs_to :profile, :inverse_of => :projects
  validates :profile, :presence => true
  
  has_many :trials, :inverse_of => :project, :dependent => :destroy
  
  validates :name, :presence => true, :length => 1..64 

  # Returns the maximum trail number in this project.
  def max_trial_number
    trials.maximum(:number) || 0
  end
end
