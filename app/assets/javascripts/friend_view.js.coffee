#= require momentjs

class @FriendView
  constructor: (@friend) ->
    template = if @friend.image_url
      """
        <div class="wall__brick is-hidden" style="background-image: url('#{@friend.image_url}')">
          <span class="wall__brick__status js-active-at">#{@activeAtText()}</span>
        </div>
      """
    else
      randomAvatar = Math.floor(Math.random() * (4 - 1)) + 1
      """
        <div class="wall__brick">
          <div class="wall_brick__icon icon--higuys-0#{randomAvatar}"></div>
        </div>
      """

    @$dom = $(template)
    @refreshActiveAt()

  remove: ->
    @$dom
      .addClass('is-hidden')
      .on 'transitionend webkitTransitionEnd oTransitionEnd otransitionend', =>  @$dom.remove()

  appendTo: ($container) ->
    $container.append(@$dom)
    @$dom.removeClass('is-hidden')

  redraw: (@friend) ->
    @$dom.css(backgroundImage: "url(#{@friend.image_url})")
    if @$dom.find('.wall_brick__icon').length > 0
      @$dom.find('.wall_brick__icon').remove()
      @$dom.append """
        <span class="wall__brick__status js-active-at">#{@activeAtText()}</span>
      """
    else
      @$dom.find('.js-active-at').text(@activeAtText())

  id: ->
    @friend.id

  refreshActiveAt: ->
    setTimeout( =>
      @$dom.find('.js-active-at').text(@activeAtText())
      @refreshActiveAt()
    , 5000)

  activeAtText: ->
    "active about #{ moment(@friend.active_at).fromNow() }"
