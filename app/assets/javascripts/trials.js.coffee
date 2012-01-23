# View for the current active trial.
class CurrentTrialView
  constructor: ->
    @onSubmit = ->
    
    @trialTabs = $('#new_trial')
    @trialTabs.tabs()

    @runButton = $('#run-button')
    @runButton.click => @onRunButtonClick()

    @form = $('#new_trial')
    @dataView = new window.DataView
    @classifierView = new window.ClassifierView
    
  onRunButtonClick: ->
    if @dataView.dataSelectValid() and @classifierView.classifierSelectValid()
      @onSubmit()
    
class TrialController
  constructor: (@trialView) ->
    @dataView = @trialView.dataView
    
    @dataView.chooseData = => @chooseData() 
      
  chooseData: ->
    dataSelect = @dataView.dataSelect
    form = @trialView.form
    
    onXhrSuccess = (data) =>
      @dataView.render(data)
    
    $.ajax({
      data: form.serialize(), success: onXhrSuccess,
      dataType: 'json', type: dataSelect.attr('data-choose-data-method'),
      url: dataSelect.attr('data-choose-data-url') 
    })
    
window.CurrentTrialView = CurrentTrialView
window.TrialController = TrialController