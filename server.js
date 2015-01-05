//
// # SimpleServer
//
// A simple chat server using Socket.IO, Express, and Async.
//
require('coffee-script/register');
var http = require('http');
var path = require('path');

var express = require('express');
var controllers = require('./controllers');

//
// ## SimpleServer `SimpleServer(obj)`
//
// Creates a new instance of SimpleServer with the following options:
//  * `port` - The HTTP port to listen on. If `process.env.PORT` is set, _it overrides this value_.
//

//var compression = require('compression')

var router = express();
var server = http.createServer(router);

//setup configs
router.set('saveDirectory', path.resolve(__dirname, 'save'));
//router.set('etag', false);

//initial all common modual
//router.use(compression());

//load controllers, views, models based on config
require('./libs/model_loader.coffee').init(router);
router.use('/statistics', controllers.init(router));

router.use(express.static(path.resolve(__dirname, 'public')));

server.listen(process.env.PORT || 3000, process.env.IP || "0.0.0.0", function(){
  var addr = server.address();
  console.log("Chat server listening at", addr.address + ":" + addr.port);
});
