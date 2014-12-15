Canvas = require('canvas')
Image = Canvas.Image

createImage = (count)->
  canvas = new Canvas(1,1)
  
  return canvas
module.exports = createImage