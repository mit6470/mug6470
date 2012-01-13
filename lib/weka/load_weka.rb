#!usr/bin/env ruby

# Loads classifier information to the database.
class WekaLoader
  def initialize(filename)
    @filename = filename  
  end
  
  def run
    s = File.read @filename
    all_classifiers = /weka\.classifiers\.Classifier=\\\n(?:\s*weka\.classifiers\.[\w\.]+,?\\?\n)+/m.match s
    classifiers = all_classifiers[0].scan /weka\.classifiers\.(?<type>\w+)\.(?<name>\w+),?\\?/
    classifiers.each do |type, name|
      c = Classifier.new(:name => name, :type => type, 
                         :program_name => "weka.classifiers.#{type}.#{name}")
      c.save!
    end
  end
end

if __FILE__ == $0
  WekaLoader.new('weka_options.props').run
end