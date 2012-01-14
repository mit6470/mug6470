# A classifier is a machine learning method. 
class Classifier < ActiveRecord::Base
  # The program name to run the classifier.
  validates :program_name, :uniqueness => true, :presence => true, 
                           :length => 1..128
  
  # Executes the classifier and returns the results.
  #
  # @return [Array] STDOUT and STDERR output strings from the execution.
  def run
    classpath = ConfigVar[:weka_classpath]
    result = IO.popen "java -cp #{classpath} #{program_name} -h 2>&1"
    result.readlines
  end
end
