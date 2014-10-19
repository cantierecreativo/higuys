#= require headroom.js/headroom
#= require headroom.js/jQuery.headroom

$ ->
  $(".js-headroom").headroom
    offset: 0
    tolerance: 0
    classes:
      initial: "headroom"
      pinned: "headroom--pinned"
      unpinned: "headroom--unpinned"
