Blip = require './blip'

$ ->
  window.blip = new Blip()
  socket = io.connect()
  socket.on 'message', (json) ->
    lat = json.geo.ll[0]
    long = json.geo.ll[1]
    window.blip.bloop lat, long, json.eventName ? 'request'
