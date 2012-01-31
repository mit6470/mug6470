module ProjectsHelper
  def close_tag
    content_tag :span, 'Delete', :class => "ui-icon ui-icon-close", 
                                 :title => "Delete"
  end

  def project_default_name
    if current_user
      "Project-#{current_user.projects.size + 1}"
    else
      ''
    end
  end
end
