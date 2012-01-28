module TrialsHelper
  def training_data_options(user)
    options = [['--Choose data--', -1]]
    data_for(user).each { |d| options << [d.short_name, d.id] unless d.is_test }
    options_for_select options
  end
  
  def data_options(user)
    options = [['--Choose data--', -1]]
    data_for(user).each { |d| options << [d.short_name, d.id] }
    options_for_select options
  end
  
  def data_for(user)
    Datum.all.select { |d| !d.profile || d.profile == user.profile }
  end
  
  def classifiers_options
    options = [['--Choose classifier--', -1]]
    Classifier.all.each { |d| options << [d.short_name, d.id] }
    options_for_select options
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
