#= require momentjs

class @FriendView
  constructor: (@friend) ->
    template = if @friend.image_url
      """
        <div class="wall__brick is-hidden" style="background-image: url('#{@friend.image_url}')">
          <div class="wall__brick__messages">
            <span class="wall__brick__status js-status-message">#{@statusMessage()}</span>
            <span class="wall__brick__active js-active-at">#{@activeAtText()}</span>
          </div>
        </div>
      """
    else
      randomAvatar = Math.floor(Math.random() * (4 - 1)) + 1
      """
        <div class="wall__brick is-hidden">
          <span class="wall__brick__status js-status-message"></span>
          <span class="wall__brick__active js-active-at"></span>
          <div class="wall_brick__icon icon--higuys-0#{randomAvatar}"></div>
        </div>
      """

    @$dom = $(template)
    @refreshActiveAt()

  remove: ->
    @$dom
      .addClass('is-hidden')
      # sorry guys, ontransitionend callback was not working properly
      setTimeout( =>
        @$dom.remove()
      , 600)

  appendTo: ($container) ->
    $container.append(@$dom).css('width') # triggers repaint
    @$dom.removeClass('is-hidden')

  redraw: (@friend) ->
    @$dom.css(backgroundImage: "url(#{@friend.image_url})")
    @$dom.find('.wall_brick__icon').remove()
    @$dom.find('.js-status-message').text(@statusMessage())
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

  statusMessage: ->
    if @friend.status_message and @friend.status_message.length > 0
      "“#{@friend.status_message}”"
    else
      ""
