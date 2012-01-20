require Rails.root.join 'lib/weka/arff_parser.rb'

# Loads classifier, data information to the database.
class WekaLoader
  
  # Loads the classifier information to the database.
  def self.load_classifiers(options_filename)
    s = File.read options_filename
    all_classifiers = /weka\.classifiers\.Classifier=\\\n(?:\s*weka\.classifiers\.[\w\.]+,?\\?\n)+/m.match s
    classifiers = all_classifiers[0].scan /weka\.classifiers\.(?:\w+\.)+\w+(?=,?\\?)/
    Classifier.delete_all
    classifiers.each do |name|
      stdout = IO.popen "java -cp #{ConfigVar[:weka_classpath]} #{name} -synopsis -h 2>&1"
      md = /^Synopsis for .+\:$/.match stdout.read
      synopsis = md && md.post_match
      synopsis &&= synopsis.strip
      c = Classifier.new :program_name => name, :synopsis => synopsis
      c.save!
    end
  end
  
  # Loads the data file name to the database.
  def self.load_data(data_dir)
    Datum.delete_all
    Dir[File.join data_dir, '*.arff'].each do |file|
      filename = File.basename file
      content = ArffParser.parse_file file
      d = Datum.new :file_name => filename, :examples => content[:examples], 
                    :num_examples => content[:examples].size,
                    :features => content[:features],
                    :num_features => content[:features].size,
                    :relation_name => content[:relation]
      begin
        d.save!
      rescue
        p content[:relation]
        raise
      end
    end
  end
end

