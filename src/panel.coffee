$     = Spine.$
require('gfx') unless $.fn.gfx
Stage ?= require('./stage')

class Panel extends Stage
  title: false
  viewport: false

  constructor: ->
    super
    @el.removeClass('stage').addClass('panel')
    @header.append($('<h2 />'))
    @setTitle(@title) if @title
    @stage ?= Stage.globalStage()
    @stage?.add(@)
    
  setTitle: (title = '') ->
    @header.find('h2:first').html(title)
    
  addButton: (text, callback, elem = @header) ->
    callback = @[callback] if typeof callback is 'string'
    button = $('<button />').text(text)
    button.tap(@proxy(callback))
    elem.append(button)
    button
  
  activate: (params = {}) ->
    effect = params.transition or params.trans
    if effect
      @effects[effect].apply(this)
    else
      @content.add(@header).show()
      @el.addClass('active')

  deactivate: (params = {}) ->
    return unless @isActive()
    effect = params.transition or params.trans
    if effect
      @reverseEffects[effect].apply(this)
    else
      @el.removeClass('active')
  
  effects:
    left: ->
      @el.addClass('active')
      @content.gfxSlideIn(@effectOptions(direction: 'left'))
      @header.gfxSlideIn(@effectOptions(direction: 'left', fade: true, distance: 50))
      @footer.gfxSlideIn(@effectOptions(direction: 'left'))
    
    right: ->
      @el.addClass('active')
      @content.gfxSlideIn(@effectOptions(direction: 'right'))
      @header.gfxSlideIn(@effectOptions(direction: 'right', fade: true, distance: 50))
      @footer.gfxSlideIn(@effectOptions(direction: 'right'))
  
  reverseEffects:
    left: ->
      @content.gfxSlideOut(@effectOptions(direction: 'right'))
      @header.gfxSlideOut(@effectOptions(direction: 'right', fade: true, distance: 50))
      @footer.gfxSlideOut(@effectOptions(direction: 'right'))
      @content.queueNext => 
        @el.removeClass('active')
    
    right: ->
      @content.gfxSlideOut(@effectOptions(direction: 'left'))
      @header.gfxSlideOut(@effectOptions(direction: 'left', fade: true, distance: 50))
      @footer.gfxSlideOut(@effectOptions(direction: 'left'))
      @content.queueNext => 
        @el.removeClass('active')
        
(module?.exports = Panel) or @Panel = Panel