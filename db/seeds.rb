# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require Rails.root.join 'lib/weka/load_weka.rb'
require Rails.root.join 'lib/tutorials/load_tutorials.rb'

puts 'Seeding the Classifier table...'
options_file = Rails.root.join 'lib/weka/weka_options.props'
WekaLoader.load_classifiers options_file

puts 'Seeding the Datum table...'
data_dir = Rails.root.join 'lib/weka/data'
WekaLoader.load_data data_dir

puts 'Seeding the Tutorial table...'
tutorial_dir = Rails.root.join 'lib/tutorials/xml'
TutorialLoader.load tutorial_dir
