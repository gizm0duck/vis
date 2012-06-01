Blip = require './blip'
LeaderBoard = require './leader_board'

$ ->
  window.blip = new Blip()
  window.leaderBoard = new LeaderBoard()
  socket = io.connect()
  socket.on 'message', (json) ->
    lat = json.geo.ll[0]
    long = json.geo.ll[1]
    window.blip.bloop lat, long, json.eventName ? 'request'
    window.leaderBoard.updateStats(json)

  