#= require caman

class @CameraFX
  constructor: (@$canvas) ->
    @canvas = @$canvas.get(0)

  apply: ->
    Caman "#camera", ->
      this.brightness(5).render()


$ ->
  fx = new CameraFX($('[data-camera-me]'))
  $('[data-camerafx]').on 'click', ->
    console.log 'fx', fx
    fx.apply()
