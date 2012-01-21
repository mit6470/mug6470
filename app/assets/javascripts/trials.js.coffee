# View for the current active trial.
class CurrentTrialView
  constructor: ->
    @onSubmit = ->
    
    new window.DataView
   
    
    @trialTabs = $('#new_trial')
    @trialTabs.tabs()

    @runButton = $('#run-button')
    @runButton.click => @onRunButtonClick()

    @form = $('#new_trial')
    
  onRunButtonClick: ->
    @onSubmit()
      
window.CurrentTrialView = CurrentTrialView