#= require jquery-tourbus
#= require jquery-cookie

$ ->
  $(".js-tour").each ->
    if Modernizr.mq('(min-width: 1024px)') and ($.cookie('tour') != 'yes')
      $(this).tourbus({}).trigger('depart.tourbus')
      $.cookie('tour', 'yes')
