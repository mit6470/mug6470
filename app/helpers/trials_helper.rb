module TrialsHelper
  def data_options
    options = [['--Choose data--', -1]]
    Datum.all.each { |d| options << [d.file_name.chomp('.arff'), d.id] }
    options_for_select options
  end
  
  def classifiers_options
    options_for_select(Classifier.all.map { 
        |d| [d.short_name, d.id] })
  end
  
  def cell_class(i, j, size)
    if i == j
      return 'result-yes'
    elsif size > 0
      return 'result-no'
    else
      return 'result-none'
    end
  end
  
  def data_examples_str(data_id, example_ids)
    ([data_id] << example_ids).flatten.join '-'
  end
end
