#= require ./friend_view
#= require ./my_view
#= require lodash

class @Wall
  constructor: (@$dom, @guestId) ->
    @friendViews = []
    @myView = new MyView(@$dom.find('.js-camera'))
    @$friendViewsContainer = @$dom.find('.js-friends')

  refreshFriends: (friends) ->
    myFriendsIds  = _.map(@friendViews, (f) -> f.id())
    newFriendsIds = _.map(friends, (f) -> f.id)
    _.pull(myFriendsIds, @guestId)
    _.pull(newFriendsIds, @guestId)

    for commonFriendId in _.intersection(newFriendsIds, myFriendsIds)
      friendview = _.find(@friendViews, (f) -> f.id() == commonFriendId)
      friend = _.find(friends, (f) -> f.id == commonFriendId)
      friendview.redraw(friend)

    for leavingFriendId in _.difference(myFriendsIds, newFriendsIds)
      friendview = _.find(@friendViews, (f) -> f.id() == leavingFriendId)
      friendview.remove()
      _.remove(@friendViews, (f) -> f.id() == leavingFriendId)

    for incomingFriendId in _.difference(newFriendsIds, myFriendsIds)
      friend = _.find(friends, (f) -> f.id == incomingFriendId)
      friendView = new FriendView(friend)
      friendView.appendTo(@$friendViewsContainer)
      @friendViews.push(friendView)

  addTempFriend: (friendId) ->
    friendView = new FriendView({id: friendId})
    friendView.appendTo(@$friendViewsContainer)
    @friendViews.push(friendView)
