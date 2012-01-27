$ ->
  projectView = new window.ProjectView
  projectController = new window.ProjectController(projectView)
  trialController = new window.TrialController(projectView.currentTrialView)  
  trialResultController = new window.TrialResultController
  window.dataView = projectView.currentTrialView.dataView
  
  tutorialView = new window.TutorialView
  
  
  hideNotice = -> 
    $('.status-bar.notice').hide('slide', {direction: 'up'}, 400)
  
  noticeTimer = setTimeout(hideNotice, 4000);

  hideOnClick = -> 
    $('.status-bar').hide('slide', {direction: 'up'}, 400)
    clearTimeout(noticeTimer)
    
  $('.status-bar a').live 'click ', hideOnClick