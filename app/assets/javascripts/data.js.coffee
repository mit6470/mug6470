# View of the data in the current trial.
class DataView
  constructor: ->
    $('#data-tabs').tabs()
    @dataSelect = $('#trial_datum_id')
    @summarySection = $('#data-summary')
    @featuresTab = $('#data-tabs-features ul')
    @examplesTab = $('#data-tabs-examples ul')
    @chooseData = ->
    @dataSelect.change => @onDataSelectChange()
      
  onDataSelectChange: ->
    if @dataSelectValid()
      @chooseData()
  
  dataSelectValid: ->
    @dataSelect.val() isnt '-1'
    
  filterExamples: ->
    console.log('Displaying selected examples')

  # @param [json] data to be rendered. It can be null if the server does not 
  #   find the data and returns nothing.
  render: (data) ->
    return unless data?
    @data = data

    # render the summary section
    numFeatures = data.features.length
    summary = """
              <h5>Summary</h5>
                <table>
                  <tbody>
                    <tr>
                      <td colspan="3">
                        <strong>Relation:</strong> #{data.relation.split('-')[0]}
                      </td>
                    </tr>
                    <tr>
                      <td><strong>Examples:</strong> #{data.num_examples}</td>
                      <td><strong>Features:</strong> #{numFeatures - 2}</td>
                      <td><strong>Class:</strong> #{data.features[numFeatures - 1].name}</td>
                    </tr>
                  </tbody>
                </table>
              """
    @summarySection.html summary
    
    # render the examples tab
    @examplesTab.html """
                      <li>
                        <div id='chart-#{data.features[numFeatures-1].name}'></div>
                      </li>
                      """
    examplesData = data.examples
    for example in examplesData
      exampleId = example[0]
      tableId = "table-#{exampleId}"
      exampleHtml = """
                    <li>
                      <div id='#{tableId}'>
                      <table>
                      <tr><th>Example #{exampleId}</th><th/></tr>
                      <tr><th>Class</th><td>#{example[numFeatures-1]}</td></tr>
                    """
      for feature, i in data.features
        if i == numFeatures - 1 or i == 0
          continue
        exampleHtml +=  """
                    <tr><th>#{data.features[i].name}</th><td>#{example[i]}</td></tr>
                        """
      exampleHtml += """
                      </table>
                      </div>
                    </li><br/>
                    """
      @examplesTab.append exampleHtml
        
    # render the features tab
    @featuresTab.empty()
    featuresData = data.features_data
    for feature, i in data.features
      continue if i == 0 # Ignore the ID feature.
      
      featureName = data.features[i].name
      chartId = "chart-#{featureName}"
      
      isClassFeature = i == numFeatures - 1
      unless isClassFeature
        checkboxId = "feature-#{featureName}"
        featureHtml = """
                      <li>
                        <input type='checkbox' id='#{checkboxId}' value='#{i}' 
                         checked='yes' name='sf[]' />
                        <label for='#{checkboxId}'>#{featureName}<label>
                        <div id='#{chartId}'></div>
                      </li>
                      """
        @featuresTab.append featureHtml

      # Renders chart if necessary.
      featureData = featuresData[i]
      unless $.isEmptyObject(featureData)
        
        reduceFn = (x, y) ->
          sum = 0
          for key, value of y
            sum += value
          if x > sum then x else sum
            
        ymax = featureData.data.reduce reduceFn, 0
        
        chartData = {
          data: featureData.data, labels: featureData.values,
          ymax: ymax, categories: featuresData[featuresData.length - 1].values,
          ylabel: 'Number of examples'
        }
        options = {stack: true, fillColors: pv.Colors.category20().range()}
        chart = new BarChart(chartData, options)
        if isClassFeature
          chart.vis.event("click", @filterExamples)
        chart.render(chartId)

window.DataView = DataView
