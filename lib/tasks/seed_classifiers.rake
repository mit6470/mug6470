require Rails.root.join 'lib/weka/load_weka.rb'

desc 'Seeds the classifier table.'
task :seed_classifiers => :environment do
  puts 'Seeding the Classifier table...'
  options_file = Rails.root.join 'lib/weka/weka_options.props'
  WekaLoader.load_classifiers options_file
end
