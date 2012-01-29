class Tutorial < ActiveRecord::Base
  validates :title, :presence => true, :length => 1..128
  validates :summary, :presence => true, :length => 1..4.kilobytes
  
  # The number of the tutorial determines the order of the tutorial.
  validates :number, :presence => true, :uniqueness => true
    
  has_many :sections, :dependent => :destroy, :inverse_of => :tutorial

  scope :by_number, order(:number)
end
