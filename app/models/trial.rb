require 'open3'

# A trial is a particular configuration of input data, classifier, and training
# and testing modes.
class Trial < ActiveRecord::Base
  serialize :output, Hash
  
  # The classifier the user chose for this trial.
  belongs_to :classifier
  
  # The input data the user chose for this trial.
  belongs_to :datum
  
  belongs_to :project, :inverse_of => :trials
  validates :profile, :presence => true
  
  validates :output, :length => 0..32.kilobytes, :allow_nil => true
  
  validates :name, :length => 0..32 
 
  # Executes the trial and returns the result and error.
  #
  # Example command for filtering attributes:
  # java -cp weka.jar weka.classifiers.meta.FilteredClassifier -t data/cpu.arff 
  #     -F "weka.filters.unsupervised.attribute.Remove -R 6" 
  #     -W weka.classifiers.rules.DecisionTable -- 
  #         -X 1 -S "weka.attributeSelection.BestFirst -D 1 -N 5"
  #
  # @return [Hash] result and error from the execution, or nil if datum or 
  #     classifier is not specified.
  def run
    if datum && classifier
      classpath = ConfigVar[:weka_classpath]
      data_file = File.join ConfigVar[:data_dir], datum.file_name
      command = "java -cp #{classpath} #{classifier} -t #{data_file} -i"
      stdin, stdout, stderr = Open3.popen3 command
      
      self.output = {}
      
      result = stdout.read   
      rest, stratified = result && 
                         result.split("=== Stratified cross-validation ===\n")
      if stratified
        rest, raw_matrix = stratified.split("=== Confusion Matrix ===\n")
        if raw_matrix
          confusion_matrix = []
          raw_matrix = raw_matrix.split("\n").reject(&:blank?) 
          confusion_matrix << raw_matrix[0].split('<--')[0].split(' ')
          raw_matrix[1..-1].
              each { |l| confusion_matrix << 
                         l.split(/\s|\||\=/).reject(&:blank?) }
          p confusion_matrix
          self.output[:result] = {}
          self.output[:result][:confusion_matrix] = confusion_matrix
        end
      end
      self.output[:error] = stderr.readlines
    end 
  end

end
