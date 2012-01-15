module TrialsHelper
  def data_options
    options_for_select(Datum.all.map { |d| [d.file_name, d.id] })
  end
end
