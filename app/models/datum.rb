# The input data for a machine learning trial.
class Datum < ActiveRecord::Base
  serialize :examples, Array
  serialize :features, Array
  
  # The user profile this data belongs to if the data is uploaded by a user.
  belongs_to :profile, :inverse_of => :data
  
  # Full path of the data file.
  validates :file_path, :presence => true, :uniqueness => true, 
                        :length => 1..512, :format => { :with => /.arff$/ }
  
  # An array of the examples of the data. The first value is the ID which starts
  # at 1.
  validates :examples, :presence => true, :length => 1..32.kilobytes
  validates :num_examples, :presence => true

  # An array of hashes with name and type keys.
  #     :name => feature name.
  #     :type => type of the feature. (numeric, text, [](nominal))
  validates :features, :presence => true, :length => 1..512

  # The number of features in the data, including ID as the first feature, and 
  # class as the last feature.
  validates :num_features, :presence => true
  
  validates :relation_name, :presence => true, :length => 1..256
  
  # True if the datum is only for testing because the class is not labeled.
  validates :is_test, :inclusion => { :in => [true, false] }
  
  # True if the datum is only temporary.
  validates :is_tmp, :inclusion => { :in => [true, false] }
  
  def to_s
    short_name
  end
  
  def short_name
    filename.chomp '.arff'
  end
  
  def filename
    File.basename file_path
  end
  
  # Returns a hash of feature data.
  # :features => array of hashes 
  #                 :name => feature name.
  #                 :type => type of the feature.
  # :features_data => aggregated data for all features.
  #                 :values => array nominal values for a feature.
  #                 :data => an array of hashes for each feature value with 
  #                          class values as keys and class value occurrences as
  #                          as values.
  #                 :missing => number of missing or invalid values for this 
  #                              feature.
  # TODO(ushadow): handle numeric values for both class and features
  def chart_data
    returnHash =  { :filename => short_name, :num_examples => num_examples, 
                    :features => features}
    class_values = features.last[:type]
    all_features = Array.new(num_features) { Hash.new 0 } 
    examples_by_class = Array.new(class_values.length) { [] }

    if nominal_type?(class_values)
      features.each_with_index do |feature, i|
        if nominal_type?(feature[:type])
          fvalues = feature[:type]
          all_features[i][:values] = fvalues
          data = Hash[fvalues.map { 
              |v| [v, Hash[class_values.map { |cv| [cv, 0] }]] }] 
          examples.each do |example| 
            v = example[i]
            if data[v].nil? 
              all_features[i][:missing] += 1
            elsif data[v][example.last]
              data[v][example.last] += 1 
            end
            if i == features.length - 1
              class_index = class_values.index example.last
              examples_by_class[class_index] << example if class_index
            end
          end
          all_features[i][:data] = fvalues.map { |v| data[v] }
        end
      end
    end
    returnHash[:features_data] = all_features
    returnHash[:class_examples] = examples_by_class
    returnHash
  end
  
  def has_string_feature?
    features.each { |f| return true if string_type? f[:type]  }
    false
  end
  
  # Returns true if the class type is nominal.
  def nominal_class_type?
    nominal_type? features.last[:type]
  end
  
  # values of the class.
  def class_values
    features.last[:type]
  end

  def string_type?(type)
    type.kind_of?(String) && type.downcase == 'string'
  end
  
  # Checks if the feature is nominal type.
  #
  # @param [Object] type feature type.
  # @return [true/false] true if type is an array.
  def nominal_type?(type)
    type.kind_of? Array
  end
  
  before_save :update_is_test
  def update_is_test
    self.is_test = true if examples[0] && examples[0].last == '?'
  end
end

