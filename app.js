#!/usr/bin/env node

var redis = require('redis');

var quit = function() {
  process.exit(0);
};

process.on('SIGINT', quit);
process.on('SIGKILL', quit);

var run = function(callback) {
  var foreman = require('./foreman.js');
    

  var terminate = exports.terminate = function() {
    foreman.terminate();
  };

  process.on('SIGKILL', function() {
    terminate();
  });

  process.on('SIGINT', function() {
    terminate();
  });

  foreman.init(function(err) {
    foreman.connect()
  });
};

if(require.main === module) {
  console.log("Initializing WhistlePunk");
  run();
}
exports.run = run;

