# A classifier is a machine learning method. 
class Classifier < ActiveRecord::Base
  # The program name to run the classifier.
  validates :program_name, :uniqueness => true, :presence => true, 
                           :length => 1..128
  
  # The information about the classifier.
  validates :synopsis, :length => 1..4.kilobytes, :allow_nil => true
  
  def to_s
    program_name
  end
end
