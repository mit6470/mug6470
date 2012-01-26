class Tutorial < ActiveRecord::Base
  validates :title, :presence => true, :length => 1..128
  validates :summary, :presence => true, :length => 1..4.kilobytes
    
  has_many :sections, :dependent => :destroy, :inverse_of => :tutorial
end
