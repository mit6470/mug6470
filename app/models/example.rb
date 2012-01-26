class Example < ActiveRecord::Base
  serialize :content, Array
  
  belongs_to :datum, :inverse_of => :examples
  validates :datum, :presence => true
  
  validates :content, :presence => true, :length => 1..1.kilobyte
  
  validates :example_id, :presence => true, 
                         :numericality => { :only_integer => true },
                         :uniqueness => { :scope => :datum_id }
end
