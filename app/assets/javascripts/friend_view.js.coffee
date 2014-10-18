class @FriendView
  constructor: (friend) ->
    template = if friend.image_url
      """
        <div class="wall__brick" style="background-image: url('#{friend.image_url}')">
          <span class="wall__brick__status">active about 2 minutes ago</span>
        </div>
      """
    else
      randomAvatar = Math.floor(Math.random() * (3 - 1)) + 1
      """
        <div class="wall__brick">
          <div class="icon--higuys-0#{randomAvatar}"></div>
        </div>
      """

    @$dom = $(template)

  remove: ->
    @$dom.remove()

