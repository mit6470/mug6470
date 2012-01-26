class TutorialView
  constructor: ->
    @sectionContainer = $('#tutorial-sections')
    @nextButton = $('#next-section', @sections)
    @prevButton = $('#prev-section', @sections)
    @sections = $('section', @sectionContainer)
    @currentSection = 0

    @sectionContainer.html @sections[@currentSection]
    
    @prevButton.click => @onPrevButtonClick()
    @nextButton.click => @onNextButtonClick()
    
  onPrevButtonClick: ->
    if @currentSection > 0
      @currentSection -= 1
      @updateSection('left')
    
    false
    
  onNextButtonClick: ->
    if @currentSection < @sections.length - 1
      @currentSection += 1
      @updateSection('right')
    
    false
    
  updateSection: (direction) ->
    @sectionContainer.html @sections[@currentSection]
    @sectionContainer.show 'slide', {direction: direction}, 400
    
window.TutorialView = TutorialView
