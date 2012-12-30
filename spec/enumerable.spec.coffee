require '../enumerable'

describe 'Enumerator', ->

describe 'an enumerable array', ->
  describe 'each', ->
    it 'returns an enumerator when called with no args', ->
      enumerator = [1,2,3].each()
      expect(enumerator.constructor.name).toBe 'Enumerator'

    it 'returns an enumerator when called with no args', ->
      enumerator = [1,2,3].each()
      obj =
        fn: ->

      spy = spyOn(obj, 'fn')
      [1,2,3].each obj.fn

      expect(spy).toHaveBeenCalledWith(1)
      expect(spy).toHaveBeenCalledWith(2)
      expect(spy).toHaveBeenCalledWith(3)

    it 'iterates when given a fn', ->
      obj =
        fn: ->

      spy = spyOn(obj, 'fn')

      [1,2,3].each obj.fn

      expect(spy).toHaveBeenCalledWith(1)
      expect(spy).toHaveBeenCalledWith(2)
      expect(spy).toHaveBeenCalledWith(3)

  describe 'map', ->
    it 'returns the result of the applied fn to each element in the list', ->
      obj =
        fn: (a)->
          a + 1

      result = [1,2,3].map obj.fn
      expect(result[0]).toBe(2)
      expect(result[1]).toBe(3)
      expect(result[2]).toBe(4)

  describe 'inject', ->
    it 'returns the injected item', ->
      obj =
        fn: (sum, a)->
          sum + a

      result = [1,2,3].inject(0, obj.fn)
      expect(result).toBe(6)

  describe 'eachWithObject', ->
    it 'returns the injected object', ->
      obj =
        fn: (collector, a)->
          collector.push(a)

      result = [1,2,3].eachWithObject([], obj.fn)
      expect(result.count()).toBe(3)


  describe 'select', ->
    it 'returns items in the list where the fn is true', ->
      obj =
        fn: (a)->
          a % 2 == 1

      result = [1,2,3].select obj.fn
      expect(result.length).toBe(2)
      expect(result[0]).toBe(1)
      expect(result[1]).toBe(3)

  describe 'reject', ->
    it 'returns items in the list where the fn is true', ->
      obj =
        fn: (a)->
          a % 2 == 1

      result = [1,2,3].reject obj.fn
      expect(result.length).toBe(1)
      expect(result[0]).toBe(2)

  describe 'count', ->
    it 'counts the items in the list', ->
      result = [1,2,3].count()
      expect(result).toBe(3)

  describe 'detect', ->
    it 'returns the first element that returns truthy', ->
      obj =
        fn: (a)->
          a % 2 == 1

      result = [1,2,3].detect obj.fn
      expect(result).toBe(1)

    it 'returns the first element that returns truthy', ->
      obj =
        fn: (a)->
          a % 2 == 1

      result = [2,2,3].detect obj.fn
      expect(result).toBe(3)

  describe 'first', ->
    it 'returns the first element', ->
      result = [3,2,1].first()
      expect(result).toBe(3)

    it 'returns the first n elements if a number is given', ->
      result = [3, 2, 1, 2, 3, 4, 5].first(3)
      expect(result.count()).toBe(3)

  describe 'all', ->
    it 'returns true if all the elements return true from the provided fn', ->
      obj =
        fn: (a)->
          typeof a is 'number'

      result = [1,2,3].all obj.fn
      expect(result).toBe(true)

    it 'returns false if any the elements return false from the provided fn', ->
      obj =
        fn: (a)->
          typeof a is 'number'

      result = [1,2,'string', 3].all obj.fn
      expect(result).toBe(false)

  describe 'any', ->
    it 'returns true if any the elements return true from the provided fn', ->
      obj =
        fn: (a)->
          typeof a is 'number'

      result = ['string', 1, 'another string'].any obj.fn
      expect(result).toBe(true)

    it 'returns false if none the elements return true from the provided fn', ->
      obj =
        fn: (a)->
          typeof a is 'string'

      result = [1,2, 3].all obj.fn
      expect(result).toBe(false)

  describe 'eachWithIndex', ->
    it "calls the fn with the item and the item's index", ->
      obj =
        fn: (a, index)->

      spy = spyOn(obj, 'fn')
      array = ['string', 1, 'another string']
      result = array.eachWithIndex obj.fn
      expect(result).toBe(array)
      expect(spy).toHaveBeenCalledWith(result[0], 0)
      expect(spy).toHaveBeenCalledWith(result[1], 1)
      expect(spy).toHaveBeenCalledWith(result[2], 2)

  describe 'drop', ->
    it 'removes the first n elements from an array', ->
      result = [1,2,3,4,5].drop(3)
      expect(result.count()).toBe 2
      expect(result[0]).toBe 4
      expect(result[1]).toBe 5

  describe 'dropWhile', ->
    it 'removes the first elements from an array until the fn is truthy', ->
      fn = (a)->
        a < 4
      result = [1,2,3,4,5].dropWhile(fn)
      expect(result.count()).toBe 2
      expect(result[0]).toBe 4
      expect(result[1]).toBe 5

  describe 'takeWhile', ->
    it 'takes the first elements from an array until the fn is false', ->
      fn = (a)->
        a < 3
      result = [1,2,3,4,5].takeWhile(fn)
      expect(result.count()).toBe 2
      expect(result[0]).toBe 1
      expect(result[1]).toBe 2

  describe 'take', ->
    it 'returns the first n elements from an array', ->
      result = [1,2,3,4,5].take(3)
      expect(result.count()).toBe 3
      expect(result[0]).toBe 1
      expect(result[1]).toBe 2
      expect(result[2]).toBe 3

  describe 'include', ->
    it 'returns true if the element is in the array', ->
      result = [1,2,3,4,5].include(3)
      expect(result).toBe true

    it 'returns false if the element is not in the array', ->
      result = [1,2,3,4,5].include(6)
      expect(result).toBe false

  describe 'none', ->
    it 'returns true if none of the elements return true for a given fn', ->
      fn = (item)->
        item > 5
      result = [1,2,3,4,5].none(fn)
      expect(result).toBe true

  describe 'one', ->
    it 'returns true if exactly one of the elements return true for a given fn', ->
      fn = (item)->
        item > 4
      result = [1,2,3,4,5].one(fn)
      expect(result).toBe true

    it 'returns false if more than one of the elements return true for a given fn', ->
      fn = (item)->
        item > 3
      result = [1,2,3,4,5].one(fn)
      expect(result).toBe false

    it 'returns false if none of the elements return true for a given fn', ->
      fn = (item)->
        item > 5
      result = [1,2,3,4,5].one(fn)
      expect(result).toBe false

  describe 'partition', ->
    it 'groups the true items into the first returned array', ->
      fn = (item)->
        item % 2 == 0

      result = [1,2,3,4,5,6,7].partition fn
      evens = result[0]
      expect(evens.count()).toBe 3
      expect(evens[0]).toBe 2
      expect(evens[1]).toBe 4
      expect(evens[2]).toBe 6

    it 'groups the false items into the second returned array', ->
      fn = (item)->
        item % 2 == 0

      result = [1,2,3,4,5,6,7].partition fn
      odds = result[1]
      expect(odds.count()).toBe 4
      expect(odds[0]).toBe 1
      expect(odds[1]).toBe 3
      expect(odds[2]).toBe 5
      expect(odds[3]).toBe 7

  describe 'toA', ->
    it 'returns the enumerable as an array', ->
      result = [1,2,3].toA()
      expect(result instanceof Array).toBe true
      expect(result[0]).toBe 1
      expect(result[1]).toBe 2
      expect(result[2]).toBe 3

  describe 'findIndex', ->
    describe 'when passed a value', ->
      it 'returns the index of the found element', ->
        result = [1,2,3].findIndex(3)
        expect(result).toBe 2

    describe 'when passed a function', ->
      it 'returns the index of the found element', ->
        fn = (item)->
          item == 3
        result = [1,2,3].findIndex fn
        expect(result).toBe 2

  describe 'reverseEach', ->
    it 'iterates over the enumerable in reverse order', ->
      a = []
      fn = (item)->
        a.push(item)

      [1,2,3].reverseEach fn
      expect(a.count()).toBe 3
      expect(a[0]).toBe 3
      expect(a[1]).toBe 2
      expect(a[2]).toBe 1

    it 'returns the array as it originally was', ->
      result = [1,2,3].reverseEach ->
      expect(result.count()).toBe 3
      expect(result[0]).toBe 1
      expect(result[1]).toBe 2
      expect(result[2]).toBe 3

  describe 'groupBy', ->
    it 'groups values by the return of the fn', ->
      fn = (item)->
        item.name
      item1 =
        name: 'Dean'
        requirement: 'food'

      item2 =
        name: 'Dean'
        requirement: 'water'

      item3 =
        name: 'tree'
        requirement: 'water'

      item4 =
        name: 'building'
        requirement: 'ground'

      result = [item1, item2, item3, item4].groupBy fn
      expect(result['Dean'].count()).toBe 2

      expect(result['tree'].count()).toBe 1
      expect(result['tree'].first().requirement).toBe 'water'

      expect(result['building'].count()).toBe 1
      expect(result['building'].first().requirement).toBe 'ground'

## Still to implement

#cycle
#each_cons
#each_slice
#grep not sure how to do this one properly, might not be able to
#zip

# require comparators
#max
#max_by
#min
#min_by
#minmax
#minmax_by
#sort
#sort_by

# 1.9.2 methods
#chunk
#collect_concat
#each_entry
#flat_map
#slice_before
