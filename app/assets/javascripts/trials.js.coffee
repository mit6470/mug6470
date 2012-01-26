# View for the current active trial.
class CurrentTrialView
  constructor: ->
    @onSubmit = ->
    
    @trialTabs = $('#current-trial')
    @trialTabs.tabs()

    @runButton = $('#run-button')
    @runButton.click => @onRunButtonClick()

    @form = $('#new_trial')
    @dataView = new window.DataView
    @classifierView = new window.ClassifierView
      
    @featureToggleButton = $('#feature-toggle-button')
    @featureToggleButton.live 'click', => @onFeatureToggle()
  
  onFeatureToggle: ->
    console.log $('#toggled-features')
    $('#toggled-features').toggle('blind', {}, 500)
    false
    
  onRunButtonClick: ->
    if @dataView.dataSelectValid() and @classifierView.classifierSelectValid()
      @onSubmit()
    
class TrialController
  constructor: (@trialView) ->
    @dataView = @trialView.dataView
    @dataView.chooseData = => @chooseData() 

    @classifierView = @trialView.classifierView
    @classifierView.chooseClassifier = => @chooseClassifier()
      
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
  
  chooseClassifier: ->
    classifierSelect = @classifierView.classifierSelect
    form = @trialView.form
    
    onXhrSuccess = (data) =>
      @classifierView.render(data)
    
    $.ajax({
      data: form.serialize(), success: onXhrSuccess,
      dataType: 'json', type: classifierSelect.attr('data-choose-classifier-method'),
      url: classifierSelect.attr('data-choose-classifier-url') 
    })
    
window.CurrentTrialView = CurrentTrialView
window.TrialController = TrialController
