class StatusView
  constructor: ->
    @$mainArticle = $('article#main')
    
    hideNotice = -> 
      $notice = $('.status-bar.ui-state-highlight')
      $notice.hide('slide', {direction: 'up'}, 400, -> $(this).remove())
    
    noticeTimer = setTimeout(hideNotice, 3000);
  
    hideOnClick = -> 
      $notice = $('.status-bar') 
      $notice.hide('slide', {direction: 'up'}, 400, -> $(this).remove())
      clearTimeout(noticeTimer)
      
    $('.status-bar a').live 'click ', hideOnClick
    
  showStatus: (msg, type)->
    icon = 'info'
    if type == 'error'
      icon = 'alert'
    statusHtml = """
                 <p class='status-bar ui-state-#{type}'>
                   <span class='ui-icon ui-icon-#{icon}'></span>
                   #{msg}
                   <span class='actions'>
                     <a href='#'>
                       <span class="ui-icon ui-icon-circle-close" title="Hide">
                          Hide
                       </span>
                     </a>
                   </span>
                 </p>
                 """
    @$mainArticle.before statusHtml
    
window.StatusView = StatusView