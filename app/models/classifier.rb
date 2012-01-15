# A classifier is a machine learning method. 
class Classifier < ActiveRecord::Base
  # The program name to run the classifier.
  validates :program_name, :uniqueness => true, :presence => true, 
                           :length => 1..128
  
  def to_s
    program_name
  end
end
