#!usr/env/bin ruby

require 'rexml/document'

class TutorialLoader
  def self.load(dir)
    Section.delete_all
    Tutorial.delete_all
    Dir[File.join dir, '*.xml'].each do |filename|
      number = File.basename(filename).split('-', 2)[0].to_i
      File.open(filename) do |file|
        doc = REXML::Document.new file
        tutorial = Tutorial.new
        article = doc.root
        tutorial.title = article.elements['h1'].text
        tutorial.summary = article.elements['summary'].text
        tutorial.number = number
        article.elements.each('section') do |sec|
          tutorial.sections.build :title => sec.elements['h2'].text, 
                                  :content => sec.to_s
        end
        tutorial.save!       
      end
    end 
  end
end
