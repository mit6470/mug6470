# The input data for a machine learing trial.
class Datum < ActiveRecord::Base
  serialize :features, Array

  has_many :examples, :dependent => :destroy, :inverse_of => :datum
    
  # The name of the data file.
  validates :file_name, :presence => true, :uniqueness => true, 
                        :length => 1..64, :format => { :with => /.arff$/ }
  
  # An array of the examples of the data.
  validates :num_examples, :presence => true

  # An array of hashes with name and type keys.
  #     :name => feature name.
  #     :type => type of the feature. (numeric, text, [](nominal))
  validates :features, :presence => true, :length => 1..512

  # The number of features in the data, including ID as the first feature, and 
  # class as the last feature.
  validates :num_features, :presence => true
  
  validates :relation_name, :presence => true, :length => 1..256
  
  def to_s
    relation_name
  end
  
  # Returns a hash of feature data.
  # :features => array of hashes 
  #                 :name => feature name.
  #                 :type => type of the feature.
  # :features_data => agregated data for all features.
  #                 :values => nominal values for a feature.
  #                 :data => an array of hashes for each feature value with 
  #                          class values as keys and class value occurrences as
  #                          as values.
  #                 :missing => number of missing or invalid values for this 
  #                              feature.
  # TODO(ushadow): handle numeric values for both class and features
  def chart_data
    returnHash =  { :relation => relation_name, :num_examples => num_examples, 
                    :features => features, :examples => examples}
    classValues = features.last[:type]
    all_features = Array.new(num_features) { Hash.new 0 } 

    if nominal_type?(classValues)
      features.each_with_index do |feature, i|
        if nominal_type?(feature[:type])
          fvalues = feature[:type]
          all_features[i][:values] = fvalues
          data = Hash[fvalues.map { 
              |v| [v, Hash[classValues.map { |cv| [cv, 0] }]] }] 
          examples.each do |example| 
            v = example[i]
            if data[v].nil? 
              all_features[i][:missing] += 1
            else
              data[v][example.last] += 1 
            end
          end
          all_features[i][:data] = fvalues.map { |v| data[v] }
        end
      end
    end
    returnHash[:features_data] = all_features
    returnHash
  end
  
  def nominal_class_type?
    nominal_type? features.last[:type]
  end
  
  # Type of the class.
  def class_values
    features.last[:type]
  end
  
  # Checks if the feature is nominal type.
  #
  # @param [Object] type feature type.
  # @return [true/false] true if type is an array.
  def nominal_type?(type)
    type.kind_of? Array
  end
end

