class StatusView
  constructor: ->
    @$mainArticle = $('article#main')
    @noticeHideTime = 3000
    @errorHideTime = 8000
    @slideTime = 4000
    
    setTimeout(@hideNotice, @noticeHideTime)
    setTimeout(@hideError, @errorHideTime)
  
    hideOnClick = -> 
      $notice = $('.status-bar') 
      $notice.hide('slide', {direction: 'up'}, @slideTime, -> $(this).remove())
      
    $('.status-bar a').live 'click ', hideOnClick
    
  hideNotice: -> 
    $notice = $('.status-bar.ui-state-highlight')
    $notice.hide('slide', {direction: 'up'}, @slideTime, -> $(this).remove())
  
  hideError: -> 
    $error = $('.status-bar.ui-state-error')
    $error.hide('slide', {direction: 'up'}, @slideTime, -> $(this).remove())
  
  # Shows the status bar and auto hides it according to the type of the message.
  # @param [String] msg the message to be displayed in the status bar.
  # @param [String] type type of the message in ['highlight', 'error' ].
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
    if type == 'error'
      setTimeout(@hideError, @errorHideTime)
    else
      setTimeout(@hideNotice, @noticeHideTime)
    
  

window.StatusView = StatusView