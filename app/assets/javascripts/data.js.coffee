# View of the data in the current trial.
class DataView
  constructor: ->
    $('#data-tabs').tabs()
    @dataSelect = $('#trial_datum_id')
    @summarySection = $('#data-summary')
    @featuresTab = $('#data-tabs-features ul')
    @$examplesTab = $('#data-tabs-examples')
    @$examplesChart = $('#class-chart', @$examplesTab)
    @$examplesList = $('#examples-list', @$examplesTab)
    @$spinner = $('#next-page-spinner')

    @chooseData = ->
    @dataSelect.change => @onDataSelectChange()
    @$dataLoader = $('#data-loader')
    
    @numExToShow = 10
  
  showDataLoader: ->
    @$dataLoader.show()
    
  hideDataLoader: ->
    @$dataLoader.hide()
       
  onDataSelectChange: ->
    if @dataSelectValid()
      @chooseData()
  
  dataSelectValid: ->
    @dataSelect.val() isnt '-1'
    
  onChartClick: ->
    @renderNewExamples();

  filterExamples: ->
    this.parent.parent.parent.showClass(this.index)
    
  renderNewExamples: ->
    @$examplesList.empty()

    showClass = if @classChart then @classChart.vis.showClass() else 0
    showClassName = @data.features[@numFeatures - 1]['type'][showClass]
    exampleHtml = """
                  <li>
                    <strong>
                      Showing examples from class: #{showClassName}
                    </strong>
                  </li>
                  """
    @$examplesList.append exampleHtml

    @curExIndex = 0
    @renderNextExamples()
    @$spinner.show()

  # @param [json] data to be rendered. It can be null if the server does not 
  #   find the data and returns nothing.
  render: (@data) ->
    return unless @data?
    
    # render the summary section
    @numFeatures = @data.features.length
    summary = """
              <h5>Summary</h5>
                <table>
                  <tbody>
                    <tr>
                      <td>Number of examples:<strong> #{@data.num_examples}</strong></td>
                      <td>Number of features:<strong> #{@numFeatures - 2}</strong></td>
                      <td>
                        Class label:<strong> #{@data.features[@numFeatures - 1].name}</strong>
                      </td>
                    </tr>
                  </tbody>
                </table>
              """
    @summarySection.html summary
    
    # render the examples tab
    @$examplesChart.html """
                         <div id='chart-#{@data.features[@numFeatures-1].name}'></div>
                         """
    @renderNewExamples()    
        
    # render the features tab
    @featuresTab.empty()
    featuresData = @data.features_data
    for feature, i in @data.features
      continue if i == 0 # Ignore the ID feature.
      
      featureName = @data.features[i].name
      chartId = "chart-#{featureName}"
      
      isClassFeature = i == @numFeatures - 1
      featureData = featuresData[i]
      
      unless isClassFeature
        checkboxId = "feature-#{featureName}"
        featureHtml = """
                      <li>
                        <div class='field'>
                          <input type='checkbox' id='#{checkboxId}' value='#{i}' 
                            checked='yes' name='sf[]' />
                          <label for='#{checkboxId}'>#{featureName}</label>
                        </div>
                        <div class='chart'>
                          #{if $.isEmptyObject(featureData) then '{Chart not available for none nominal feature type.}' else ''}
                          <div id='#{chartId}'></div>
                        </div>
                      </li>
                      """
        @featuresTab.append featureHtml

      # Renders chart if necessary.
      unless $.isEmptyObject(featureData)
        reduceFn = (x, y) ->
          sum = 0
          for key, value of y
            sum += value
          if x > sum then x else sum
            
        ymax = featureData.data.reduce reduceFn, 0
        
        chartData = {
          data: featureData.data, labels: featureData.values,
          ymax: ymax + 2, categories: featuresData[featuresData.length - 1].values,
          ylabel: 'Number of examples'
        }
        options = {stack: true, fillColors: pv.Colors.category20().range()}
        if isClassFeature
          options['clickCallback'] = @filterExamples
          @classChart = new BarChart(chartData, options)
          @classChart.render(chartId)
          classChartElem = $('#'+chartId)
          classChartElem.click => @onChartClick()
        else
          chart = new BarChart(chartData, options)
          chart.render(chartId)

  renderNextExamples: ->
    showClass = if @classChart then @classChart.vis.showClass() else 0
    examples = @data.class_examples[showClass]
    if @curExIndex >= examples.length
      @$spinner.hide()
      return

    for example in examples[@curExIndex...@curExIndex + @numExToShow]
      exampleId = example[0]
      tableId = "table-#{exampleId}"
      exampleHtml = """
                    <li>
                      <div id='#{tableId}'>
                      <table>
                      <tr><th>Example #{exampleId}</th><th/></tr>
                      <tr><th>Class</th><td>#{example[@numFeatures-1]}</td></tr>
                    """
      for feature, i in @data.features
        if i == @numFeatures - 1 or i == 0
          continue
        exampleHtml +=  """
                    <tr><th>#{@data.features[i].name}</th><td>#{example[i]}</td></tr>
                        """
      exampleHtml += """
                      </table>
                      </div>
                    </li>
                    """
      @$examplesList.append exampleHtml
    @curExIndex += @numExToShow
  
  
class DataController
  constructor: (@dataView) ->
    $(document).scroll => @observeScroll()
    
  observeScroll: ->
    @renderNextPage() if @readyForNextPage()
    
  renderNextPage: ->
    @dataView.renderNextExamples()
  
  readyForNextPage: ->
    return false if !$('#next-page-spinner').is(':visible')
      
    threshold = 200
    bottomPosition = $(window).scrollTop() + $(window).height()
    distanceFromBottom = $(document).height() - bottomPosition
    return distanceFromBottom <= threshold
    
window.DataView = DataView
window.DataController = DataController
