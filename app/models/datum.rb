# The input data for a machine learing trial.
class Datum < ActiveRecord::Base
  serialize :examples, Array
  serialize :features, Array
  
  # The name of the data file.
  validates :file_name, :presence => true, :uniqueness => true, 
                        :length => 1..64, :format => { :with => /.arff$/ }
  
  # A hash of the examples of the data.
  validates :examples, :presence => true, :length => 1..32.kilobytes
  validates :num_examples, :presence => true

  validates :features, :presence => true, :length => 1..512

  # The number of features in the data.
  validates :num_features, :presence => true
  
  validates :relation_name, :presence => true, :length => 1..256
  
  def to_s
    relation_name
  end
end

