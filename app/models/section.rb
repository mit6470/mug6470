class Section < ActiveRecord::Base
  belongs_to :tutorial, :inverse_of => :sections
  validates :tutorial, :presence => true
  
  validates :name, :presence => true, :length => 1..128
  validates :content, :presence => true, :length => 1..32.kilobytes
end
