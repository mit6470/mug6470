# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'Seeding the Classifiers table...'
require Rails.root.join 'lib/weka/load_weka.rb'

options_file = Rails.root.join 'lib/weka/weka_options.props'

WekaLoader.new(options_file).run
