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
    console.log data
    @histogramTab.html 'Got data'
    
window.DataView = DataView