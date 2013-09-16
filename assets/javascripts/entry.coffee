Blip = require './blip'
LeaderBoard = require './leader_board'

getBaseAgent = (userAgent) ->
  return 'dalvik' if userAgent.indexOf('Dalvik') != -1
  return 'ios' if userAgent.indexOf('Learnist') != -1
  return 'web'

$ ->
  window.blip = new Blip()
  window.leaderBoard = new LeaderBoard()
  socket = io.connect()
  socket.on 'message', (json) ->
    lat = json.geo.ll[0]
    long = json.geo.ll[1]
    window.blip.bloop lat, long, getBaseAgent(json.agent)
    # window.leaderBoard.updateStats(json)

  