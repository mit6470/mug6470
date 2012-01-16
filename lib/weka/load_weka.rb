# Loads classifier, data information to the database.
class WekaLoader
  
  # Loads the classifier information to the database.
  def self.load_classifiers(options_filename)
    s = File.read options_filename
    all_classifiers = /weka\.classifiers\.Classifier=\\\n(?:\s*weka\.classifiers\.[\w\.]+,?\\?\n)+/m.match s
    classifiers = all_classifiers[0].scan /(weka\.classifiers\.(?:\w+\.)+\w+),?\\?/
    Classifier.delete_all
    classifiers.each do |name|
      c = Classifier.new :program_name => name.first
      c.save!
    end
  end
  
  # Loads the data file name to the database.
  def self.load_data(data_dir)
    Datum.delete_all
    Dir[File.join data_dir, '*'].each do |file|
      filename = File.basename file
      d = Datum.new :file_name => filename
      d.save!
    end
  end
end

