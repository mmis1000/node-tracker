Canvas = require('canvas')
Image = Canvas.Image

createImage = (count)->
  canvas = new Canvas(200,40)
  ctx = canvas.getContext('2d');
  
  ctx.font = '30px Mono'
  ctx.textAlign = "center"
  ctx.textBaseline = "middle"
  ctx.fillText("" + count, 100, 20);
  
  return canvas
module.exports = createImage