class TutorialView
  constructor: ->
    @sectionContainer = $('#tutorial-sections')
    @$nextButton = $('#next-button')
    @$prevButton = $('#prev-button')
    @$backButton = $('#back-button')
    @sections = $('section', @sectionContainer)
    @currentSection = 0
  
    @$prevButton.button { icons: { primary: 'ui-icon-carat-1-w'} }
    @$prevButton.button { disabled: true }
    @$nextButton.button { icons: { secondary: 'ui-icon-carat-1-e'} }
    @$backButton.button { icons: { secondary: 'ui-icon-arrowreturnthick-1-n'} }
    
    @sectionContainer.html @sections[@currentSection]
    
    @$nextButton.click => @onNextButtonClick()
    @$prevButton.click => @onPrevButtonClick()
    
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
    if @currentSection >= @sections.length - 1
      @$nextButton.button { disabled: true }
    else if @currentSection > 0  
      @$nextButton.button { disabled: false }
      @$prevButton.button { disabled: false }
    else 
      @$prevButton.button { disabled: true }
      
window.TutorialView = TutorialView
