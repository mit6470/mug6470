class ClassifierView
  constructor: ->
    @classifierSelect = $('#trial_classifier_id')
    @classifierInfo = $('#classifier-info')
    @chooseClassifier = ->
    @classifierSelect.change => @onClassifierSelectChange()
  
  onClassifierSelectChange: ->
    if @classifierSelectValid()
      @chooseClassifier()

  classifierSelectValid: ->
    @classifierSelect.val() isnt '-1'

  render: (data) ->
    return unless data?
    @classifierInfo.html data.synopsis
      
window.ClassifierView = ClassifierView
