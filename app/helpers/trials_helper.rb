module TrialsHelper
  def data_options
    options = [['Choose data', -1]]
    Datum.all.each { |d| options << [d.file_name, d.id] }
    options_for_select options
  end
  
  def classifiers_options
    options_for_select(Classifier.all.map { 
        |d| [d.program_name.split('.', 3)[2], d.id] })
  end
end
