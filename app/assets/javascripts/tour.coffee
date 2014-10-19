#= require jquery-tourbus

$ ->
  if Modernizr.mq('(min-width: 1024px)')
    $(".js-tour").tourbus({}).trigger('depart.tourbus')
