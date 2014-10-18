class @FriendView
  constructor: (friend) ->
    TEMPLATE = """
      <div class="wall__brick" style="background-image: url('#{friend.photo_url}')">
        <div class="icon--higuys-01"></div>
        <span class="wall__brick-status">active about 2 minutes ago</span>
      </div>
    """
    @$dom = $(TEMPLATE)

