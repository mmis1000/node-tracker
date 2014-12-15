url = require 'url'
controller = 
  renderEngine : 'ejs'
  init : (router)->
    router.use (req, res, next)->
      next()

module.exports = controller