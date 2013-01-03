class Enumerable
  aliases:
    collect: 'map'
    entries: 'toA'
    find: 'detect'
    findAll: 'select'
    member: 'include'
    reduce: 'inject'

  functions:
    [
      'all'
      'any'
      'count'
      'detect'
      'drop'
      'dropWhile'
      'eachWithIndex'
      'eachWithObject'
      'first'
      'findIndex'
      'groupBy'
      'include'
      'inject'
      'map'
      'none'
      'one'
      'partition'
      'reject'
      'reverseEach'
      'select'
      'take'
      'takeWhile'
      'toA'
    ]

  constructor: (@obj)->
    @addFunctionsToObj(@obj)
    @addAliasesToObj(@obj)

  addFunctionsToObj: (obj)->
    @functions.each (method)=>
      obj[method] = @[method] unless obj[method]

    @obj.enumerator = @

  addAliasesToObj: (obj)->
    for alias, method of @aliases
      obj[alias] = @[method] unless obj[alias]

  eachWithIndex: (fn)->
    index = 0
    @each (item)->
      fn(item, index)
      index += 1
      item


  count: (fn) ->
    total = 0
    @each ->
      total += 1
    total

  map: (fn) ->
    @eachWithObject [], (result, item)->
      result.push(fn(item))

  include: (obj)->
    try
      @each (item)->
        raise 'found' if obj == item
    catch error
      return true
    false

  inject: (injectedItem, fn)->
    @each (item)->
      injectedItem = fn(injectedItem, item)
    injectedItem

  eachWithObject: (injectedItem, fn)->
    @each (item)->
      fn(injectedItem, item)
    injectedItem

  select: (fn) ->
    @eachWithObject [], (selected, item)->
      result = fn(item)
      selected.push(item) if result

  detect: (fn) ->
    detected = null
    try
      @each (item)->
        if fn(item)
          detected = item
          raise 'found'
    catch error
    detected

  findIndex: (arg) ->
    detectedIndex = null
    try
      @eachWithIndex (item, index)->
        if arg instanceof Function
          result = arg(item)
        else
          result = (item == arg)
        if result
          detectedIndex = index
          raise 'found'
    catch error
    detectedIndex

  reject: (fn) ->
    @eachWithObject [], (selected, item)->
      result = fn(item)
      selected.push(item) unless result

  all: (fn) ->
    try
      @each (item)->
        raise 'found' unless fn(item)
    catch error
      return false
    true

  any: (fn) ->
    try
      @each (item)->
        raise 'found' if fn(item)
    catch error
      return true
    false

  first: (count)->
    if count? && count > 1
      return @take(count)
    detected = null
    try
      @each (item)->
        detected = item
        raise 'found'
    catch error
    detected

  take: (count)->
    result = []
    @eachWithIndex (item, index)->
      result.push(item) if index < count
    result

  takeWhile: (fn)->
    result = []
    try
      @each (item)->
        raise 'found' unless fn(item)
        result.push(item)
    catch error
    result

  drop: (count)->
    result = []
    @eachWithIndex (item, index)->
      result.push(item) unless index < count
    result

  dropWhile: (fn)->
    found = false
    @eachWithObject [], (result, item)->
      found ||= !fn(item)
      result.push(item) if found

  none: (fn)->
    !@any(fn)

  one: (fn)->
    foundOne = false
    try
      @each (item)->
        result = fn(item)
        raise 'found' if foundOne && result
        foundOne ||= result
    catch error
      return false
    foundOne

  partition: (fn)->
    trueArray = []
    falseArray = []
    @each (item)->
      if fn(item)
        trueArray.push(item)
      else
        falseArray.push(item)
    [trueArray, falseArray]

  toA: ->
    @select -> true

  reverseEach: (fn)->
    array = @toA()
    array.slice().reverse().each(fn)
    array

  groupBy: (fn)->
    @eachWithObject {}, (result, item)->
      key = fn(item)
      result[key] ||= []
      result[key].push(item)

  @makeEnumerable = (obj)->
    new Enumerable(obj)

Array.prototype.each = (fn)->

  return @enumerator unless fn
  for item in @
    fn(item)
  @

Enumerable.makeEnumerable(Array.prototype)

window['Enumerable'] = Enumerable if window?
module.exports = Enumerable if module?

