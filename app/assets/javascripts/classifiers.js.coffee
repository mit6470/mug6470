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
    return unless data?.synopsis?
    
    html = []
    for line in data.synopsis.split("\n")
      html.push "<p>#{line}</p>"
    @classifierInfo.html html.join('')
      
window.ClassifierView = ClassifierView
