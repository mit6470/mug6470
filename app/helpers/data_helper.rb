module DataHelper
  def status_html(msg)
    html = ["<p class='status-bar error' data-pwnfx-reveal-target='status-ba'>", 
            "#{msg}<span class='actions'>",
            "#{link_to 'Hide', '#', 'data-pwnfx-reveal' => 'status-bar', 'data-pwnfx-reveal-trigger' => 'click-hide'}",
            "</span></p>"].join ''
    html.html_safe
  end
end
