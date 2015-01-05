url = require 'url'
imgFactory = require './img.coffee'
imgInvisibleFactory = require './img_invisible.coffee'
precreate_invisibleCanvas = imgInvisibleFactory()
precreate_canvas = (x for x in [0..100]).map (i)-> imgFactory(i)
count = {}

controller = 
  renderEngine : 'ejs'
  init : (router, modules)->
    #console.log('registered router')
    #console.log modules
    counter = (modules.get 'com.gmail.mmis10002.node_tracker').counter
    newEtag = (modules.get 'com.gmail.mmis10002.node_tracker').newEtag
    siteInfo = (modules.get 'com.gmail.mmis10002.node_tracker').siteInfo()
    router.use (req, res, next)->
      currentEtag = req.get 'If-None-Match'
      currentEtag = currentEtag || newEtag()
      res.set 'ETag', currentEtag
      res.etag = currentEtag
      res.setHeader 'Last-Modified', (new Date()).toUTCString()
      res.setHeader 'cache-control', 'private, max-age=0, must-revalidate'
      console.log req.originalUrl, req.get 'Accept-Language'
      next()
    
    router.get '/html/:id', (req, res, next)->
      ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
      agent = req.get('User-Agent');
      referer = req.get('referer');
      
      id = req.params.id
      
      count = counter.add(id)
      
      console.log id, ip, count, agent, referer, res.etag
      
      res.render 'count', {count : count, name : id, site : siteInfo}

    router.get '/png/:id', (req, res, next)->
      ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
      agent = req.get('User-Agent');
      referer = req.get('referer');
      id = req.params.id
      
      count = counter.add(id)
      
      console.log id, ip, count, agent, referer, res.etag
      
      res.setHeader 'Content-Type', 'image/png'
      res.setHeader 'Content-Disposition', 'inline; filename="' + (encodeURIComponent id) + '_display.png' + '"'
      image = precreate_canvas[count] || imgFactory(count)
      image.pngStream().pipe(res)
      #res.render 'count', {count : count[id]}

    router.get '/png_invisible/:id', (req, res, next)->
      ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
      agent = req.get('User-Agent');
      referer = req.get('referer');
      id = req.params.id
      
      count = counter.add(id)
      
      console.log id, ip, count, agent, referer, res.etag
      
      res.setHeader 'Content-Type', 'image/png'
      res.setHeader 'Content-Disposition', 'inline; filename="' + (encodeURIComponent id) + '_display.png' + '"'
      #image = imgInvisibleFactory(count[id])
      precreate_invisibleCanvas.pngStream().pipe(res)
      #res.render 'count', {count : count[id]}
module.exports = controller