url = require 'url'
controller = 
  renderEngine : 'ejs'
  init : (router)->
    #console.log('registered router')
    router.get '/time', (req, res, next)->
      res.render 'time'
module.exports = controller