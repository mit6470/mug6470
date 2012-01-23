# The view of the current active project.
class ProjectView
  constructor: ->
    @currentTrialView = new window.CurrentTrialView

    onAddTab = (event, ui) =>
      $(ui.panel).append @resultHtml
      @projectTabs.tabs 'select', "\##{ui.panel.id}"

    onCloseTab = (target) =>
      index = $('li', @projectTabs).index(target)
      @projectTabs.tabs 'remove', index
      trialId = target.find('a').attr('data-trial-href').split('-')[1]
      if parseInt(trialId)
        deleteUrl = "/trials/#{trialId}"
        $.ajax({ dataType: 'json', type: 'DELETE', url: deleteUrl });

    @projectTabs = $('#current-project').tabs({
      tabTemplate: '''
                   <li>
                     <a href="#{href}" data-trial-href="#{href}">#{label}</a> 
                     <span class="ui-icon ui-icon-close">Remove Tab</span>
                   </li> 
                   ''',
      add: onAddTab
    })
    
    $('#project-nav span.ui-icon-close').live 'click', 
                                              -> onCloseTab($(this).parent()) 
  
  # Renders the trial result.  
  renderResult: (@resultHtml) ->
    # result = trial.output.result
    # error = trial.output.error
    # @resultHtml = ''
    # if error.length > 0
      # @resultHtml = "<p>#{error[0]}</p>"
    # else
      # matrix = result?.confusion_matrix
      # if matrix?
        # thead = ("<th>#{cell}</th>" for cell in matrix[0]).join('')
        # thead = "<thead><tr>#{thead}</tr></thead>"
#       
        # tbody = []
        # for row in result.confusion_matrix[1..-1]
          # rowHtml = ("<td>#{cell}</td>" for cell in row[0...-2]).join('') +
                    # "<td>#{row[row.length - 2]} = #{row[row.length - 1]}</td>"
          # tbody.push "<tr>#{rowHtml}</tr>"                     
#         
        # @resultHtml = """
                     # <article>
                       # <table>
                         # #{thead}
                         # <tbody>  
                         # #{tbody.join('')}
                        # </tbody>
                       # </table>
                     # <article>
                     # """

    trialElement = $($(@resultHtml).filter('[data-trial-id]')[0])
    trialId = trialElement.attr('data-trial-id')
    trialName = $.trim trialElement.text()     
    # If the user is not logged in, the trial id is -1 and the trial name should
    # be unique, so we use the name as the id. 
    if trialId is '-1'
      trialId = trialName          
    @projectTabs.tabs 'add', "\#trial-#{trialId}", "#{trialName}", 1

# ProjectController handles user interactions on the project view.
class ProjectController
  constructor: (@projectView) ->
    @currentTrialView = @projectView.currentTrialView
    @currentTrialView.onSubmit = => @submit()
    
  # Submits the current trial form to run the trial.  
  submit: ->
    form = @currentTrialView.form
      
    onXhrSuccess = (data) =>
      @projectView.renderResult data
      
    $.ajax({
      data: form.serialize(), success: onXhrSuccess,
      dataType: 'html', type: form.attr('method'), url: form.attr('action')
    })
    
window.ProjectController = ProjectController 
window.ProjectView = ProjectView  