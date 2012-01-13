#!usr/bin/env ruby

# Loads classifier information to the database.
class WekaLoader
  def run
    command = 'jar tf weka.jar weka/classifiers'
    output = IO.popen command
    puts output.readlines
  end
end

if __FILE__ == $0
  WekaLoader.new.run
end