class Datum < ActiveRecord::Base
  # The name of the data file.
  validates :file_name, :presence => true, :uniqueness => true, 
                        :length => 1..64, :format => { :with => /.arff$/ }
end
