class ProjectIndexView
  constructor: ->
    @$projectForm = $('#new_project').dialog({
      autoOpen: false,
      modal: true,
      height: 300,
      width: 350,
    })
    $newProjectButton = $('#new-project-button')
    $newProjectButton.click => @showDialog()
    
  showDialog: ->
    @$projectForm.dialog 'open'
  
window.ProjectIndexView = ProjectIndexView
