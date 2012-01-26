$ ->
  projectView = new window.ProjectView
  projectController = new window.ProjectController(projectView)
  trialController = new window.TrialController(projectView.currentTrialView)  
  window.dataView = projectView.currentTrialView.dataView
  
  tutorialView = new window.TutorialView
  
  hideStatus = -> $('.status-bar.notice').addClass('hidden')
  setTimeout(hideStatus, 4000);
