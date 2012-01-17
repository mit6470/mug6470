module TrialsHelper
  def data_options
    options_for_select(Datum.all.map { |d| [d.file_name, d.id] })
  end
  
  def classifiers_options
    options_for_select(Classifier.all.map { |d| [d.program_name, d.id] })
  end
end
