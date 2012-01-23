# View of the data in the current trial.
class DataView
  constructor: ->
    $('#data-tabs').tabs()
    @dataSelect = $('#trial_datum_id')
    @featuresTab = $('#data-tabs-features ul')
    @summarySection = $('#data-summary')
    @chooseData = ->
    @dataSelect.change => @onDataSelectChange()
      
  onDataSelectChange: ->
    if @dataSelectValid()
      @chooseData()
  
  dataSelectValid: ->
    @dataSelect.val() isnt '-1'
    
  # @param [json] data to be rendered. It can be null if the server does not 
  #   find the data and returns nothing.
  render: (data) ->
    return unless data?
    numFeatures = data.features.length
    summary = """
              <h5>Summary</h5>
                <table>
                  <tbody>
                    <tr>
                      <td>
                        <strong>Relation:</strong> #{data.relation.split('-')[0]}
                      </td>
                      <td><strong>Examples:</strong> #{data.num_examples}</td>
                      <td><strong>Features:</strong> #{numFeatures - 1}</td>
                      <td><strong>Class:</strong> #{data.features[numFeatures - 1].name}</td>
                    </tr>
                  </tbody>
                <table>
              """
    @summarySection.html summary
    @featuresTab.empty()
    featuresData = data.features_data
    for feature, i in data.features
      continue if i == 0 # Ignore the ID feature.
      featureName = data.features[i].name
      chartId = "chart-#{featureName}"
      checkboxId = "feature-#{featureName}"
      isClassFeature = i == numFeatures - 1
      disabled = if isClassFeature then 'disabled' else ''
      hiddenInput = ''
      if isClassFeature 
        hiddenInput = "<input hidden name='sf[]' value='#{i}' />"
      featureHtml = """
                    <li>
                      <input type='checkbox' id='#{checkboxId}' value='#{i}' 
                       checked='yes' #{disabled} name='sf[]' />
                      <label for='#{checkboxId}'>#{featureName}<label>
                      #{hiddenInput}
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
        chart.render(chartId)

window.DataView = DataView