# View for the current active trial.
class CurrentTrialView
  constructor: ->
    @onSubmit = ->
    
    @trialTabs = $('#current-trial')
    @trialTabs.tabs()

    @$runButton = $('#run-button')
    @$runButton.click => @onRunButtonClick()

    @form = $('#new_trial')
    @dataView = new window.DataView
    @classifierView = new window.ClassifierView
      
    onFeatureToggle = ($target) ->
      $target.parent().prev().toggle('blind', {}, 500)
      $($target.children()).toggle()
      false

    @$featureToggleButtons = $('.feature-toggle-button')
    @$featureToggleButtons.live 'click', -> onFeatureToggle($(this))
    
    @$trialModeTabs = $('#current-trial-run')
    @$trialModeTabs.tabs()
    @$trialModeTabs.tabs 'select', 0
    @$trialModeInput = $('#trial-mode')
    
    @trialModeValues = ['cv', 'test']
    
    @$testDataSelect = $('#trial_test_datum_id')
    @$runLoader = $('#run-loader')
    
    @$tweetSearchForm = $('#tweet_search')
    if (@$tweetSearchForm.length != 0)
      @$tweetTerm = $('#tweet_search_term')
      @$tweetButton = $('#tweet_search_button')
      @$tweetSearchForm.submit => @onTweetSearch()
      @$tweetButton.live 'click', => @onTweetSearch()
  
  hideRunLoader: ->
    @$runLoader.hide();
    
  showRunLoader: ->
    @$runLoader.show();
    
  disableRunButton: ->
    @$runButton.attr('disabled', 'disabled')
    
  enableRunButton: ->
    @$runButton.removeAttr 'disabled'
      
  
  # Perform the run button action if the input is valid.  
  onRunButtonClick: ->
    errorMsg = ''
    if @dataView.dataSelectValid() and @classifierView.classifierSelectValid()
      index = @$trialModeTabs.tabs('option', 'selected')
      @$trialModeInput.val @trialModeValues[index]
      if index is 0 or @testDataSelectValid()
        @onSubmit()
      else  
        errorMsg = 'Please select a test data set.'
    else
      errorMsg = 'Please select both a data set and a classifier.'
    
    if errorMsg    
      window.statusView.showStatus errorMsg, 'error'
  
  testDataSelectValid: ->
    @$testDataSelect.val() isnt '-1'
      
  onTweetSearch: ->
    form = @$tweetSearchForm

    onXhrSuccess = (data) =>
      @$testDataSelect.append """
          <option value="#{data.id}">#{data.relation_name}</option>
                         """
      console.log(data)
      
    $.ajax({
      data: form.serialize(), success: onXhrSuccess,
      dataType: 'json', type: @$tweetTerm.attr('data_tweet_search_method'),
      url: @$tweetTerm.attr('data_tweet_search_url')
    })

# Handles the event on trial result view.
class TrialResultController
  constructor: ->
    
    onConfusionMatrixClick = (target) ->
      params = target.attr('data-confusion-matrix').split '-'
      dataId = params[0]
      currentIndex = 1
      examplesToRequest = params[currentIndex..currentIndex + 9]
      
      $classifiedExampleSection = target.closest('section').next()
      $classifiedExampleSection.empty()
      target.addClass('clicked')
      
      onXhrSuccess = (data) ->
        $classifiedExampleSection.append data
      
      if examplesToRequest.length > 0
        $.ajax({
          data: {examples: examplesToRequest},
          success: onXhrSuccess,
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
      
    onBeforeSend = =>
      @dataView.showDataLoader()
    
    onComplete = =>
      @dataView.hideDataLoader()
      
    $.ajax({
      data: form.serialize(), success: onXhrSuccess,
      dataType: 'json', type: dataSelect.attr('data-choose-data-method'),
      url: dataSelect.attr('data-choose-data-url'),
      beforeSend: onBeforeSend, complete: onComplete 
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
