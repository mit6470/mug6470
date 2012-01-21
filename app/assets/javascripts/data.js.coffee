class DataView
  constructor: ->
    $('#data-tabs').tabs()
    @dataSelect = $('#trial_datum_id')
    @histogramTab = $('#data-tabs-histogram')
    
    @chooseData = ->
    @dataSelect.change => @onDataSelectChange()
      
  onDataSelectChange: ->
    @chooseData()
    
  render: (data) ->
    @histogramTab.empty()
    return unless data?
    featuresData = data.features_data
    for featureData, i in featuresData
      unless $.isEmptyObject(featureData)
        chartData = {
          data: featureData.data, labels: featureData.values,
          ymax: 14, categories: featuresData[featuresData.length - 1].values,
          ylabel: 'examples'
        }
        options = {stack: true}
        chart = new BarChart(chartData, options)
        id = "chart-#{data.features[i].name}"
        @histogramTab.append("<div id='#{id}'></div>")
        chart.render(id)
    
window.DataView = DataView