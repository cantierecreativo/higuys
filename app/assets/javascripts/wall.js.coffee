#= require ./friend_view
#= require ./my_view

class @Wall
  constructor: (@$dom) ->
    @friendViews = []
    @myView = new MyView(@$dom.find('.js-camera'))
    @$friendViewsContainer = @$dom.find('.js-friends')

  refreshFriends: (friends) ->
    for friendView in @friendViews
      friendView.remove()

    @friendViews = []

    for friend in friends
      friendView = new FriendView(friend)
      @friendViews.push(friendView)
      @$friendViewsContainer.append(friendView.$dom)

