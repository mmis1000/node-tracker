class Counter
  constructor : ()->
    @counts = {}
  get : (name)->
    return @counts[name] || 0
  add : (name)->
    current = @counts[name] || 0
    current++;
    @counts[name] = current
    return @counts[name]
    
counter = {
  namespace : 'com.gmail.mmis10002.node_tracker',
  init : (module, app)->
    module.counter = new Counter
    module.newEtag = ()->
      Date.now().toString(16) + '-' + 'xxxxxxxx'.replace /x/g, ()-> return (Math.floor (16 * Math.random())).toString 16
      
}

module.exports = counter