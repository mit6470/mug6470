module TrialsHelper
  def training_data_options(user)
    options = [['-- Choose data --', -1]]
    data_for(user).each { |d| options << [d.short_name, d.id] unless d.is_test }
    options_for_select options
  end
  
  def test_data_options(user)
    options = [['-- Choose test data --', -1]]
    data_for(user).each { |d| options << [d.short_name, d.id] }
    options_for_select options
  end
  
  def data_for(user)
    Datum.all.select { |d| !d.is_tmp && 
                           (!d.profile || user && d.profile == user.profile) }
  end
  
  def classifiers_options
    options = [['--Choose classifier--', -1]]
    Classifier.all.each { |d| options << [d.short_name, d.id] }
    options_for_select options
  end
  
  def cell_class(i, j, size)
    if i == j
      return 'yes'
    elsif size > 0
      return 'no'
    else
      return 'none'
    end
  end
  
  def data_examples_str(trial, example_ids)
    id = (trial.test_mode? && trial.test_datum && trial.test_datum_id) || 
          trial.datum_id
    ([id] << example_ids).flatten.join '-'
  end
end
