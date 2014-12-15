fs = require 'fs'
path = require 'path'

getPaths = (rootDir) ->
  files = fs.readdirSync(rootDir)
  paths = []

  for file in files
    if file[0] != '.'
      filePath = "#{rootDir}/#{file}"
      stat = fs.statSync(filePath)

      if stat.isDirectory()
        paths.push(file)
      if stat.isFile()
        paths.push(file)

  return paths

init = (app)->
  models = app.get 'models'
  
  if not models
    models = new (require './namespace_holder.coffee')
    app.set 'models', models
  
  modelFolder = path.resolve __dirname, '../models/'
  
  for name in getPaths modelFolder
    try
      model = require path.resolve modelFolder, name
      namespace = models.get model.namespace
      if not namespace
        throw new Error "fail to create namespace #{model.namespace}"
      model.init namespace, app
    catch e
      console.error e
  
  return models
  
module.exports.init = init