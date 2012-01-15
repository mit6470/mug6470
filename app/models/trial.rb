# A trial is a particular configuration of input data, classifier, and training
# and testing modes.
class Trial < ActiveRecord::Base
  # The classifier the user chose for this trial.
  belongs_to :classifier
  
  # The input data the user chose for this trial.
  belongs_to :datum
 
  # Executes the trial and returns the results.
  #
  # @return [Array(String)] STDOUT from the execution.
  def run
    if datum && classifier
      classpath = ConfigVar[:weka_classpath]
      data_file = File.join ConfigVar[:data_dir], datum.file_name
      result = IO.popen "java -cp #{classpath} #{classifier} -t #{data_file} -i"
      result.readlines
    end 
  end

end
