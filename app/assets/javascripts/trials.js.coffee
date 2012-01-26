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
    $('#toggled-features').toggle('blind', {}, 500)
    false
    
  onRunButtonClick: ->
    if @dataView.dataSelectValid() and @classifierView.classifierSelectValid()
      @onSubmit()
      
class TrialResultController
  constructor: ->
    
    onConfusionMatrixClick = (target) ->
      params = target.attr('data-confusion-matrix').split '-'
      dataId = params[0]
      $.ajax({
        data: {examples: params[1..-1]},
        dataType: 'html', type: 'GET', url: "/data/#{dataId}"
      })  
    
    $('[data-confusion-matrix]').live 'click', 
                                      -> onConfusionMatrixClick($(this))
    
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
window.TrialResultController = TrialResultController
window.TrialController = TrialController
