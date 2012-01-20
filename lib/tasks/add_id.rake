desc 'Adds an id attribute to each data file.'

data_directory = "#{Rails.root.join('lib/weka/data')}"
directory data_directory

task :add_id => [data_directory, :files]

Dir[Rails.root.join('lib/weka/data_raw/*')].each do |raw_file|
  filename = File.basename raw_file
  processed_file = "#{File.join data_directory, filename}"
  file processed_file => raw_file do
    program = "weka.filters.unsupervised.attribute.AddID"
    command = ["java -cp #{Rails.root.join 'lib/weka/weka.jar'}", "#{program}", 
               "-i #{raw_file}", 
               "-o #{processed_file}"].join ' '   
    system command
  end
  task :files => processed_file
end

