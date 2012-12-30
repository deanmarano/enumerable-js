# Enumerable.js

## Why
After having been a Ruby programmer for a year, I've found that
one of my favorite parts of Ruby is the Enumerable module. Any seasoned
Rubyist will extoll it's virtues and always try to use the best function
for the job. While the [Underscore](http://underscorejs.org/) library
provides the majority of these functions, it requires a slightly different
syntax, which is slightly less pleasing to the eye. My goal was to make
the transition from Ruby to Javascript (or hopefully Coffeescript) an easier
one for Ruby developers.

This library DOES modify the standard behavior of Array. While frowned upon
in the Javascript land, we Rubyists have no problem with monkey patches. All
functions are new, no old functions are overwritten so in theory this should
not affect any existing code (unless there is already monkey patching).

I also wanted to get a better hold of everything that was in the Enumerable
module in Ruby - this was a fantastic exercise and I'd recommended it to anyone
interested in Ruby.

## What You Do
Add a method called `each` to your class. This method should be an iterator
over all of the objects you wish to enumerator, calling a function that is passed
as an argument with each item.

Examples:
```javascript
(function() {
  var MyEnumerableClass ;

  MyEnumerableClass = (function() {
    MyEnumerableClass.prototype.myChildren = [];

    MyEnumerableClass.prototype.each = function(fn) {
      var item, _i, _len;
      for (_i = 0, _len = this.myChildren.length; _i < _len; _i++) {
        item = this.myChildren[_i];
        fn(item);
      }
      return this;
    };
    return MyEnumerableClass;
  })();
)
```
and then call:

```javascript
Enumerable.makeEnumerable(MyEnumerableClass.prototype);
```
and then magic happens.

## What It Does
By writing the `each` function, this allows tons of additional helper methods to
be created. Since they are all implemented using `each`, you get a variety of new
methods on your class for free. In addition to modifying your class, enumerable.js
makes Array enumerable by default. Which means that you can do:

```coffeescript
[1,2,3,4,5].map (item)->
  item + 1
# returns [2,3,4,5,6]
```

## The Functions
The best documentation can be found here: http://ruby-doc.org/core-1.9.3/Enumerable.html
* all
* any
* count
* detect
* drop
* dropWhile
* eachWithIndex
* eachWithObject
* first
* findIndex
* groupBy
* include
* inject
* none
* one
* partition
* reject
* reverseEach
* select
* take
* takeWhile
* toA

The following aliases are also available:
* collect: map
* entries: toA
* find: detect
* findAll: select
* member: include
* reduce: inject

## Gotchas

### Style
Standard JS style uses camelCase as opposed to snake_case, so all functions have been
camelCased. In addition, JS does not allow the `?` character in method names, so it has
simply been dropped. These methods function as the do in Ruby (returning true or false)
but that handy indicator is sadly missing. If you have any suggestions or ideas on a
different way to implement this, please let me know!

### Incompatible Functions
A few functions were unable to match the exact functionality of Ruby:

* eachWithObject - This works as expected with objects, however breaks when using
primitives (string, number, boolean, null, undefined). This is due to the fact that
primitives can't be modified (and as such are basically passed by value) whereas objects
are passed by reference. A way around this is by wrapping your primative in
a simple object.

```coffeescript
[1,2,3,4].eachWithObject {value: 0}, fn(sum, item)-> sum.value += item
# returns {value: 10}
```
* grep - Works as expected only if passed a Regex, but since JS has no notion of Ranges
that functionality does not work. Due to Ruby's extensive matching capabilities, this
seems exceedingly difficult to fully implement.


### Comparative Functions - NOT YET IMPLEMENTED
Some of the functions of Enumerable require a comparator (min, max, sort, .etc) which
in Ruby is provided by the `<=>` or the spaceship. Since this is not a legal function
name in JS, I opted for boring and chose `compare`. If your class implements compare
as in the example, you will get the following additional functions:

* max
* maxBy
* min
* minBy
* minmax
* minmaxBy
* sort
* sortBy

### Warning
Totally untested in the real world.
TODO: Test that it doesn't cause issues with the following libraries.

* jQuery
* Underscore.js
* Backbone.js

## Specs
Jasmine specs were used through npm. To install jasmine-node:
```
npm install -g jasmine-node
```

And then to run the specs:
```
jasmine-node  --coffee spec/enumerable.spec.coffee
```
