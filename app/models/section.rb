class Section < ActiveRecord::Base
  belongs_to :tutorial, :inverse_of => :sections
  validates :tutorial, :presence => true
  
  validates :title, :presence => true, :length => 1..128
  validates :content, :presence => true, :length => 1..32.kilobytes
  
  def next
    tutorial.sections.where('id > ?', id).first
  end
  
  def prev
    tutorial.sections.where('id < ?', id).first
  end
end
