$ ->
  window.statusView = new window.StatusView
  projectView = new window.ProjectView
  projectController = new window.ProjectController(projectView)
  trialController = new window.TrialController(projectView.currentTrialView)  
  trialResultController = new window.TrialResultController
  window.dataView = projectView.currentTrialView.dataView
  window.trialView = projectView.currentTrialView
  tutorialView = new window.TutorialView