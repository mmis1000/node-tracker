url = require 'url'
count = {}

controller = 
  renderEngine : 'ejs'
  init : (router, modules)->
    #console.log('registered router')
    #console.log modules
    counter = (modules.get 'com.gmail.mmis10002.node_tracker').counter
    newEtag = (modules.get 'com.gmail.mmis10002.node_tracker').newEtag
    siteInfo = (modules.get 'com.gmail.mmis10002.node_tracker').siteInfo()
    
    router.get '/:id/result.html', (req, res, next)->
      ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
      agent = req.get('User-Agent');
      referer = req.get('referer');
      
      id = req.params.id
      
      count = counter.get(id)
      
      console.log id, ip, count, agent, referer, res.etag
      
      res.render 'count', {count : count, name : id, site : siteInfo}

    router.get '/:id/result.json', (req, res, next)->
      ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
      agent = req.get('User-Agent');
      referer = req.get('referer');
      id = req.params.id
      
      count = counter.get(id)
      
      console.log id, ip, count, agent, referer, res.etag
      
      res.json({ count: count })

    router.get '/:id/result.js', (req, res, next)->
      ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
      agent = req.get('User-Agent');
      referer = req.get('referer');
      id = req.params.id
      
      count = counter.get(id)
      
      console.log id, ip, count, agent, referer, res.etag
      
      res.jsonp({ count: count })

module.exports = controller