require Rails.root.join 'lib/tutorials/load_tutorials.rb'

desc 'Seeds the tutorial table.'
task :seed_tutorials => :environment do
  puts 'Seeding the Tutorial table...'
  tutorial_dir = Rails.root.join 'lib/tutorials/xml'
  TutorialLoader.load tutorial_dir
end
