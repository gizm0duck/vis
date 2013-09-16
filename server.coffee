process.env.NODE_ENV ?= 'development'

redis = require 'redis'
express = require 'express'
browserify = require 'browserify'
geoip = require 'geoip-lite'
io = require 'socket.io'
redisConf = require './redis_conf'
# stats = require './stats'

app = express.createServer()

bundle = browserify
  entry: "#{__dirname}/assets/javascripts/entry.coffee"
  watch: process.env.NODE_ENV != 'production'
  debug: true

app.configure 'production', ->
  app.use express.logger()
  app.use express.errorHandler()

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.static(__dirname + '/public')
  app.use bundle
  app.use express.bodyParser()
  app.use express.methodOverride()

socket = io.listen app
app.listen 3040

handleMessage = (channel, json) ->
  try
    json = JSON.parse json
    return unless json.notification?.name == "process_action.action_controller"
    return if json.payload?.headers?.HTTP_X_REQUESTED_WITH == 'XMLHttpRequest'
    # console.log json

    ip = json.payload?.headers?.HTTP_X_REAL_IP
    geo = if ip == '127.0.0.1' then defaultGeo() else geoip.lookup(ip)
    agent = json.payload?.headers?.HTTP_USER_AGENT || 'default'
    return unless geo?
    # stats.update(geo) unless ip == '127.0.0.1'
  
    data =
      ip: ip
      geo: geo
      agent: agent
      # stats: stats
  
    socket.sockets.emit 'message', data
  catch e
    # do nothing

defaultGeo =() ->
  { 
    range: [ ],
    country: 'US',
    region: 'OH',
    city: 'Wauseon',
    ll: [ '41.5492', '-84.1417' ] }

client = redis.createClient(6379, redisConf[process.env.NODE_ENV].host)
client.subscribe('narratus_pub_sub')
client.on 'message', handleMessage
