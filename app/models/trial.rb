# A trial is a particular configuration of input data, classifier, and training
# and testing modes.
class Trial < ActiveRecord::Base
  serialize :output, Hash
  serialize :selected_features, Array
    
  # The project this trial belongs to.
  belongs_to :project, :inverse_of => :trials
  validates :project, :presence => true

  # The classifier the user chose for this trial.
  belongs_to :classifier
  validates :classifier, :presence => true
    
  # The input data the user chose for this trial.
  belongs_to :datum
  validates :datum, :presence => true

  belongs_to :test_datum, :class_name => :Datum
  validates :test_datum, :presence => { :if => :test_mode? }
  
  # Name of the trial. 
  validates :name, :length => 0..32, :presence => true 

  # The output of this trial.  
  validates :output, :length => 0..32.kilobytes, :presence => true 
 
  # An array of integer indices as selected features used in training. It does
  # not include the class feature which should always be included.
  validates :selected_features, :length => 0..128, :presence => true
  
  # Training and testing mode
  validates :mode, :length => 1..32
  
  # The number of the trial the user has run in a project.
  validates :number, :presence => true, :uniqueness => { :scope => :project_id }
  
  # Returns true if the testing mode is using test data.
  def test_mode?
    mode == 'test'
  end
  
  # Returns true if using unlabeled test data for testing.
  def unlabeled_test?
    test_mode? && test_datum && test_datum.is_test
  end

end

# :nodoc: Trial execution
class Trial
  # Executes the trial and returns the result and error.
  #
  # Example command for filtering attributes:
  # java -cp weka.jar weka.classifiers.meta.FilteredClassifier -t data/cpu.arff 
  #     -F "weka.filters.unsupervised.attribute.Remove -R 6" 
  #     -W weka.classifiers.rules.DecisionTable -- 
  #         -X 1 -S "weka.attributeSelection.BestFirst -D 1 -N 5"
  #
  # @return [Boolean] true if input is valid.
  def run
    self.output = { :result => {}, :error => {}, :warning => {} }
    if datum && classifier && selected_features && mode && (!test_mode? || test_datum)
      classpath = ConfigVar[:weka_classpath]
      data_file = datum.file_path
      rm_features = (0..datum.num_features - 2).to_a - selected_features
      rm_features_str = rm_features.map { |i| i + 1 }.join ','
      command = ["java -cp #{classpath}",
                 "weka.classifiers.meta.FilteredClassifier -p 1", 
                 "-t #{data_file}"]
      if test_mode?
        command << "-T #{test_datum.file_path}"  
      end
      
      command << ["-F \"weka.filters.unsupervised.attribute.StringToWordVector -S\"", 
                  "-W weka.classifiers.meta.FilteredClassifier --"].join(' ') if
                      datum.has_string_feature?
      
      command << ["-F \"weka.filters.unsupervised.attribute.Remove",
                  "-R #{rm_features_str}\"",
                  "-W #{classifier.program_name}"].join(' ')
      
      stdin, stdout, stderr = Open3.popen3 command.join ' '
      
      stderr.readlines.each do |line|
        next if line.strip!.blank?
        if md = /Warning:(?<warning>.+)/i.match(line)
          self.output[:warning] = md[:warning]
          break
        else
          k, v = line.split(':', 2)
          self.output[:error] = v || k  
          return true
        end
      end

      # Only output accuracy and confusion matrix if the class type is nominal.
      if datum.nominal_class_type?
        num_class_values = datum.class_values.size 
        matrix = Array.new(num_class_values) { 
              Array.new(num_class_values) { [] } }
        regex = /^\s*\d+\s+(?<actual>\d+):(?<actual_label>[^\s]+)\s+(?<predicted>\d+):[^\s]+\s+\+?\s+(?<confidence>[\d\.]+)\s*\((?<id>\d+)\)/ 
        total = num_correct = 0
        stdout.readlines.each do |l|
          if md = regex.match(l) 
            id = md[:id].to_i
            actual = md[:actual_label] == '?' ? -1 : md[:actual].to_i 
            predicted = md[:predicted].to_i
            confidence = md[:confidence].to_f
            
            self.output[:result][id] = { :actual => actual,
                :predicted => predicted, :confidence => confidence }
            if actual > 0
              matrix[actual - 1][predicted - 1] << id 
              total += 1
              num_correct += 1 if actual == predicted
            end
          end
        end
        if !unlabeled_test?
          self.output[:result][:confusion_matrix] = matrix
          self.output[:result][:accuracy] = num_correct.to_f / total if total > 0
        end
      end
      true
    else
      false
    end 
  end

end
