# View for the trial workbench.
class CurrentTrialView
  constructor: ->
    @onSubmit = ->
    
    new window.DataView
   
    
    @trialTabs = $('#current-trial')
    @trialTabs.tabs()

    @runButton = $('#run-button')
    @runButton.click => @onRunButtonClick()

    @form = $('#new_trial')
    
  onRunButtonClick: ->
    @onSubmit()
      
# TrialController handles user interactions.
class TrialController
  constructor: (@view) ->
    @view.onSubmit = => @submit()
    
  submit: ->
    form = @view.form
      
    onXhrSuccess = (data) =>
      @view.renderResult data
      
    $.ajax({
      data: form.serialize(), success: onXhrSuccess,
      dataType: 'json', type: form.attr('method'), url: form.attr('action')
    });
    
window.TrialController = TrialController
window.CurrentTrialView = CurrentTrialView