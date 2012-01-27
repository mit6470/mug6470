module ApplicationHelper
  def ok_image_tag
    image_tag 'checkmark.png', :alt => 'OK'
  end

  def close_status_tag
    content_tag :a, content_tag(:span, 'Hide', 
                                :class => 'ui-icon ui-icon-circle-close', 
                                :title => 'Hide'), 
                    :href => '#'
  end
  
  def alert_icon_tag
    content_tag :span, 'Alert', :class => 'ui-icon ui-icon-alert'
  end
  
  def info_icon_tag
    content_tag :span, 'Info', :class => 'ui-icon ui-icon-info'
  end
  
end

