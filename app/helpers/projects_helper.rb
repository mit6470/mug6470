module ProjectsHelper
  def close_tag
    content_tag :span, 'Delete', :class => "ui-icon ui-icon-close", 
                                 :title => "Delete"
                       
  end
end
