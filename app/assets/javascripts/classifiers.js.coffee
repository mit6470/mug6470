class ClassifierView
  constructor: ->
    @classifierSelect = $('trial_classifier_id')

  classifierSelectValid: ->
    @classifierSelect.val() isnt '-1'
      
window.ClassifierView = ClassifierView
