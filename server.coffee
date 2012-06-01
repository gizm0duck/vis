process.env.NODE_ENV ?= 'development'

redis = require 'redis'
express = require 'express'
browserify = require 'browserify'
geoip = require 'geoip-lite'
io = require 'socket.io'
redisConf = require './redis_conf'
stats = require './stats'

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

app.listen 3000
socket = io.listen app
exports.stats = {}
events = ['firstRequest', 'request']
handleMessage = (channel, json) ->
  json = JSON.parse json
  return unless json.ip
  return unless json.eventName in events
  console.log 'message', json
  if json.ip == '127.0.0.1'
    json.geo = defaultGeo()
  else
    json.geo = geoip.lookup(json.ip)
    json.stats = stats.update(json.geo)
  
  socket.sockets.emit 'message', json

defaultGeo =() ->
  { 
    range: [ ],
    country: 'US',
    region: 'OH',
    city: 'Wauseon',
    ll: [ '41.5492', '-84.1417' ] }

client = redis.createClient(6379, redisConf[process.env.NODE_ENV].host)
client.subscribe('Learnist:Visualizer')
client.on 'message', handleMessage
