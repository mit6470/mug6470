$ ->
  projectView = new window.ProjectView
  projectController = new window.ProjectController(projectView)
  trialController = new window.TrialController(projectView.currentTrialView)  
  
  hideStatus = -> $('.status-bar.notice').addClass('hidden')
  setTimeout(hideStatus, 4000);
