class ProjectView
  constructor: ->
    @projectTabs = $('#current-project')
    @projectTabs.tabs()
    
    new CurrentTrialView
    
  renderResult: (output) ->
    result = output.result
    error = output.error
    resultHtml = ''
    if error.length > 0
      resultHtml = "<p>#{error[0]}<p>"
    else
      matrix = result?.confusion_matrix
      if matrix?
        thead = ("<th>#{cell}</th>" for cell in matrix[0]).join('')
        thead = "<thead><tr>#{thead}</tr></thead>"
      
        tbody = []
        for row in result.confusion_matrix[1..-1]
          rowHtml = ("<td>#{cell}</td>" for cell in row[0...-2]).join('') +
                    "<td>#{row[row.length - 2]} = #{row[row.length - 1]}</td>"
          tbody.push "<tr>#{rowHtml}</tr>"                     
        resultHtml = """
                     <table>
                       #{thead}
                       <tbody>  
                       #{tbody.join('')}
                      </tbody>
                     </table>
                     """
    
    $('#trial-result').html resultHtml  
    @projectTabs.tabs 'add', 2   