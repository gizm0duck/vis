var util = require('util'),
    EventEmitter = require('events').EventEmitter,
    redis = require('redis'),
    geoip = require('geoip-lite');

var Foreman = function() {
  EventEmitter.call(this);
};

util.inherits(Foreman, EventEmitter);

Foreman.prototype.init = function(callback) {
  this.redis_key = "Learnist:Visualizer";
  callback();
};

Foreman.prototype.connect = function(callback) {
  this.connectRedis();
  this.startProcessing();
};

Foreman.prototype.connectRedis = function() {
  this.redis_client = redis.createClient(6379, "127.0.0.1");
  console.log("Redis connected.");
  
  this.redis_client.once('end', function() {
    console.log("Lost connection to Redis. Reconnecting...");
    this.connectRedis();
  }.bind(this));  
};

Foreman.prototype.terminate = function() {
  
};

Foreman.prototype.startProcessing = function() {
  console.log("starting to process", this.redis_key);
  this.redis_client.subscribe(this.redis_key);
  this.redis_client.on("message", function(channel, message) {
    this.handleMessage(message);
  }.bind(this));
  
};

Foreman.prototype.handleMessage = function(json_msg) {
  json = JSON.parse(json_msg);
  if (json.ip) {
    // FYI will not work for localhost
    if (json.ip == '127.0.0.1') {
      json.ip = '66.249.66.162';
    }
    var geo = geoip.lookup(json.ip)
    // # publish to client here
    console.log(json.ip, geo);
  }
};

var foreman = new Foreman();

module.exports = foreman;