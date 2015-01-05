console.log 'test'
fs = require 'fs'
express = require 'express'
path = require 'path'
getDirs = (rootDir) ->
  files = fs.readdirSync(rootDir)
  dirs = []

  for file in files
    if file[0] != '.'
      filePath = "#{rootDir}/#{file}"
      stat = fs.statSync(filePath)

      if stat.isDirectory()
        dirs.push(file)

  return dirs

controllers = getDirs __dirname

main = (app ,models, basePath = '/')->
  originalViewEngine = null
  originalViewFolder = null
  
  #initial all controller instance
  requiredControllers = []

  for controller in controllers
    if 0 is controller.search /^__/g
      continue
    try
      controller = {
        path : controller
        module : require "./#{controller}/"
      }
      requiredControllers.push controller
    catch e
      console.error e
      
  router = express.Router()
  
  #save old settings first
  router.use (req, res, next)->
    originalViewEngine = app.get 'view engine'
    originalViewFolder = app.get 'views'
    next()
  
  #initial all sub controllers
  for i in requiredControllers
    if i.path == '_index'
      solvePath = ''
    else
      solvePath = "#{i.path}"
    subrouter = express.Router()
    
    router.use "/#{solvePath}", subrouter
    
    #use a middleware to prepare environment for each controller
    subrouter.use ((engine, viewFolder, req,res, next)->
      app.set 'view engine', engine
      app.set 'views', viewFolder
      next()
    ).bind(null, i.module.renderEngine, (path.resolve __dirname, solvePath, 'views'))
    
    i.module.init subrouter, app.get 'models'
  
  ###
    restore old settings before leave this router,
    so it won't break controllers and views added by other module
  ###
  router.use (req, res, next)->
    app.set 'view engine', originalViewEngine
    app.set 'views', originalViewFolder
    next()
  
  #mount the router to the entry
  #app.use basePath, router
  return router
  
module.exports.init = main