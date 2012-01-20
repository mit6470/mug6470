# The input data for a machine learing trial.
class Datum < ActiveRecord::Base
  serialize :content, Hash
  
  # The name of the data file.
  validates :file_name, :presence => true, :uniqueness => true, 
                        :length => 1..64, :format => { :with => /.arff$/ }
  
  # A hash of the full content of the data.
  validates :content, :presence => true, :length => 1..32.kilobytes

  # The number of attributes in the data.
  validates :num_attributes, :presence => true
  
  def to_s
    file_name
  end
end

