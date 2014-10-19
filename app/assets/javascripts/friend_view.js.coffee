#= require momentjs

class @FriendView
  constructor: (@friend) ->
    template = if @friend.image_url
      """
        <div class="wall__brick" style="background-image: url('#{@friend.image_url}')">
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
    @$dom.remove()

  refreshActiveAt: ->
    setTimeout( =>
      @$dom.find('.js-active-at').text(@activeAtText())
      @refreshActiveAt()
    , 5000)

  activeAtText: ->
    "active about #{ moment(@friend.active_at).fromNow() }"

