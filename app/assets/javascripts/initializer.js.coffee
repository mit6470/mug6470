$ ->
  projectView = new window.ProjectView
  projectController = new window.ProjectController(projectView)
  trialController = new window.TrialController(projectView.currentTrialView)  