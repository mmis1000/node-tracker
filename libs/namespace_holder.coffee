class namespaces
  constructor : ()->
    @reserved = ['reserved', 'create']
  create : (name)->
    if name in @reserved
      return null
    if 'string' != typeof name
      return null
    if !@[name]
      @[name] = {}
    return @[name]
  
  namespaces::get = namespaces::create

module.exports = namespaces