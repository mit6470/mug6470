# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
class TrialView
  constructor: ->
    @onSubmit = ->
    
    new window.DataView
    @workflowTabs = $('#workflow-tabs')
    @workflowTabs.tabs()
    @runButton = $('#run-button')
    @form = $('#new_trial')
    @runButton.click => @onRunButtonClick()
    
  onRunButtonClick: ->
    @onSubmit()
    
  renderResult: (output) ->
    result = ("<p>#{line}</p>" for line in output.result).join ''
    error = "<p>#{output.error && output.error[0]}</p>"
    $('#trial-result').html result + error 
    @workflowTabs.tabs 'select', 2    
    
class TrialController
  constructor: () ->
    @view = new TrialView
    @view.onSubmit = => @submit()
    
  submit: ->
    form = @view.form
      
    onXhrSuccess = (data) =>
      @view.renderResult data
      
    $.ajax({
      data: form.serialize(), success: onXhrSuccess,
      dataType: 'json', type: form.attr('method'), url: form.attr('action')
    });
    
window.TrialController = TrialController