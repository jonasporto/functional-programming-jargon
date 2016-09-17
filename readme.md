# Functional Programming Jargon With Ruby

Functional programming (FP) provides a lot of advantages and its popularity has been increasing as a result.  However each programming paradigm comes with its own unique jargon and FP is no exception.  By providing a glossary we hope to make learning FP easier.

This Project is a fork of [Programming Jargon with Javascript](https://github.com/hemanth/functional-programming-jargon) ported to a Ruby Version

This should make this glossary as accessible and as possible and introduce features from the new revision.

Where applicable, this document uses terms defined in the [Fantasy Land spec](https://github.com/fantasyland/fantasy-land)

<!-- RM(noparent,notop) -->

* [Arity](#arity)
* [Higher-Order Functions (HOF)](#higher-order-functions-hof)
* [Partial Application](#partial-application)
* [Currying](#currying)
* [Function Composition](#function-composition)
* [Purity](#purity)
* [Side effects](#side-effects)
* [Idempotent](#idempotent)
* [Point-Free Style](#point-free-style)
* [Predicate](#predicate)
* [Contracts](#contracts)
* [Guarded Functions](#guarded-functions)
* [Categories](#categories)
* [Value](#value)
* [Constant](#constant)
* [Functor](#functor)
* [Pointed Functor](#pointed-functor)
* [Lift](#lift)
* [Referential Transparency](#referential-transparency)
* [Equational Reasoning](#equational-reasoning)
* [Lazy evaluation](#lazy-evaluation)
* [Monoid](#monoid)
* [Monad](#monad)
* [Comonad](#comonad)
* [Applicative Functor](#applicative-functor)
* [Morphism](#morphism)
* [Isomorphism](#isomorphism)
* [Setoid](#setoid)
* [Semigroup](#semigroup)
* [Foldable](#foldable)
* [Traversable](#traversable)
* [Type Signatures](#type-signatures)
* [Union type](#union-type)
* [Product type](#product-type)
* [Option](#option)


<!-- /RM -->

## Arity

The number of arguments a function takes. From words like unary, binary, ternary, etc. This word has the distinction of being composed of two suffixes, "-ary" and "-ity." Addition, for example, takes two arguments, and so it is defined as a binary function or a function with an arity of two. Such a function may sometimes be called "dyadic" by people who prefer Greek roots to Latin. Likewise, a function that takes a variable number of arguments is called "variadic," whereas a binary function must be given two and only two arguments, currying and partial application notwithstanding (see below).

```ruby

sum = ->(a, b) { a + b }
puts sum.arity #=> 2

# The arity of sum is 2

```

## Higher-Order Functions (HOF)

A function which takes a function as an argument and/or returns a function.

```ruby

filter = lambda do |pred, xs|
    result = []
    xs.each_with_index do |_, idx|
        result << xs[idx] if pred.call(xs[idx])
    end
    result
end

```

```ruby

is = lambda do |type|
    ->(x) { x.instance_of? type }
end


```

```ruby

filter.call(is.call(Fixnum), [0, '1', 2, nil]) #=> [0, 2]

```

## Partial Application

Partially applying a function means creating a new function by pre-filling some of the arguments to the original function.


```ruby
# Helper to create partially applied functions
# Takes a function and some arguments

partial = lambda do |f, *args|
    ->(*moreArgs) { f.call *(args + moreArgs) }
end

# Something to apply
add3 = ->(a, b, c) { a + b + c }

# Partially applying `2` and `3` to `add3` gives you a one-argument function
fivePlus = partial.call(add3, 2, 3)

fivePlus.call(4) #=> 9
```

Partial application helps create simpler functions from more complex ones by baking in data when you have it. [Curried](#currying) functions are automatically partially applied.

## Currying

The process of converting a function that takes multiple arguments into a function that takes them one at a time.

Each time the function is called it only accepts one argument and returns a function that takes one argument until all arguments are passed.

```ruby

sum = ->(a, b) { a + b }

curriedSum = lambda do |a|
    ->(b) { a + b }
end

curriedSum.call(40).call(2) #=> 42


add2 = curriedSum.call(2)
add2.call(10) #=> 12

```

## Function Composition

The act of putting two functions together to form a third function where the output of one function is the input of the other.

```ruby

compose = lambda do |f, &g|
    -> (a) { f.call g.call(a) }
end

floor_and_to_string = compose.call(->(val) { val.to_s }, &:floor)

floor_and_to_string.call(121.212121) #=> "121"

```

## Purity

A function is pure if the return value is only determined by its
input values, and does not produce side effects.

```ruby

greet = ->(name) { 'Hi, ' + name }
greet.call 'Brianne' #=> "Hi, Brianne"

name = 'Brianne'
greet = -> { greeting = 'Hi, ' + name }

greet.call #=> "Hi, Brianne"

```

## Side effects

A function or expression is said to have a side effect if apart from returning a value, it interacts with (reads from or writes to) external mutable state.

```ruby
require 'date'

different_every_time = Date.new

```

```ruby
puts 'IO is a side effect!'

```

## Idempotent

A function is idempotent if reapplying it to its result does not produce a different result.

```ruby
#f(f(x)) = f(x)
```

```ruby
10.abs.abs #=> 10
```

```ruby
[2, 1].sort.sort.sort #> [1, 2]
```

## Point-Free Style

Writing functions where the definition does not explicitly identify the arguments used. This style usually requires [currying](#currying) or other [Higher-Order functions](#higher-order-functions-hof). A.K.A Tacit programming.

```ruby
# Given

map = lambda do |fn|
    ->(list) { list.map &fn }
end

add = lambda do |a|
    ->(b) { a + b }
end

# Then

# Not points-free - `numbers` is an explicit argument
increment_all = ->(numbers) { map.call(add.call(1)).call numbers }
increment_all.call([1, 2, 3, 4]) #=> [2, 3, 4, 5]

# Points-free - The list is an implicit argument
increment_all_2 = map.call(add.call(1))
increment_all_2.call([1, 2, 3, 4]) #=> [2, 3, 4, 5]

```

`increment_all` identifies and uses the parameter `numbers`, so it is not points-free.  `increment_all_2` is written just by combining functions and values, making no mention of its arguments.  It __is__ points-free.


## Predicate
A predicate is a function that returns true or false for a given value. A common use of a predicate is as the callback for array filter.

```ruby

predicate = ->(a) { a > 2 }
[1, 2, 3, 4].select &predicate #=> [3, 4]

```

## Contracts

TODO

## Guarded Functions

TODO

## Categories

Objects with associated functions that adhere to certain rules. E.g. [Monoid](#monoid)

## Value

Anything that can be assigned to a variable.

```ruby
5
{name: 'John', age: 30}
->(a) { a }
[1]
nil

```

## Constant

A variable that cannot be reassigned once defined.

```ruby
#TODO 
```

Constants are [referentially transparent](#referential-transparency). That is, they can be replaced with the values that they represent without affecting the result.


## Functor

An object that implements a `map` function which, while running over each value in the object to produce a new object, adheres to two rules:

```ruby

object = [Object.new]

```

and

```ruby

# composable

g = ->(x) { x }
f = ->(y) { y }

object.map{ |x| f.call(g.call(x)) } === object.map(&g).map(&f) #=> true

```

(`f`, `g` be arbitrary functions)

A common functor in Ruby is `Array` since it abides to the two functor rules:

```ruby

[1, 2, 3].map{|x| x} #=> [1,2,3]

```
and

```ruby
f = ->(x) { x + 1 }
g = ->(x) { x * 2 }

[1, 2, 3].map{|x| f.call(g.call(x)) } #=> [3, 5, 7]
[1, 2, 3].map(&g).map(&f)  #=> [3, 5, 7]

```

## Pointed Functor
An object with an `of` function that puts _any_ single value into it.

ES2015 adds `Array.of` making arrays a pointed functor.

```js
Array.of(1) # [1]
```

## Lift

Lifting is when you take a value and put it into an object like a [functor](#pointed-functor). If you lift a function into an [Applicative Functor](#applicative-functor) then you can make it work on values that are also in that functor.

Some implementations have a function called `lift`, or `lift_a2` to make it easier to run functions on functors.


## Referential Transparency

An expression that can be replaced with its value without changing the
behavior of the program is said to be referentially transparent.

Say we have function greet:

```ruby
greet = -> { 'Hello World!' }
```

Any invocation of `greet()` can be replaced with `Hello World!` hence greet is
referentially transparent.

##  Equational Reasoning

When an application is composed of expressions and devoid of side effects, truths about the system can be derived from the parts.

## Lazy evaluation

Lazy evaluation is a call-by-need evaluation mechanism that delays the evaluation of an expression until its value is needed. In functional languages, this allows for structures like infinite lists, which would not normally be available in an imperative language where the sequencing of commands is significant.

## Monoid

An object with a function that "combines" that object with another of the same type.

One simple monoid is the addition of numbers:

```ruby
1 + 1 #=> 2
```
In this case number is the object and `+` is the function.

An "identity" value must also exist that when combined with a value doesn't change it.

The identity value for addition is `0`.

```ruby
1 + 0 #=> 1
```

It's also required that the grouping of operations will not affect the result (associativity):

```ruby
1 + (2 + 3) === (1 + 2) + 3 #=> true
```

Array concatenation also forms a monoid:

```ruby
[1, 2].concat [3, 4] #=> [1, 2, 3, 4]
```

The identity value is empty array `[]`

```ruby
[1, 2].concat([]) #=> [1, 2]
```

If identity and compose functions are provided, functions themselves form a monoid:

```ruby

identity = -> a { a }

foo = -> b { b }

compose = -> (f, g) { ->(x) {f.call(g.call(x))}}

compose.call(foo, identity).call('param') == compose.call(identity, foo).call('param') #=> true

# and

compose.call(foo, identity).call('param') == foo.call('param') #=> true

```

## Monad

A monad is an object with [`of`](#pointed-functor) and `chain` functions. `chain` is like [`map`](#functor) except it un-nests the resulting nested object.

```ruby

# Implementation
class Array
 def chain
   reduce([]) {|acc, it| acc.concat(yield it)}
 end
end

# Usage

['cat,dog', 'fish,bird'].chain{|a| a.split(',')} #=> ['cat', 'dog', 'fish', 'bird']

#Contrast to map

['cat,dog', 'fish,bird'].map{|a| a.split(',')} # => [["cat", "dog"], ["fish", "bird"]] 

```

`of` is also known as `return` in other functional languages.
`chain` is also known as `flatmap` and `bind` in other languages.

## Comonad

An object that has `extract` and `extend` functions.

```ruby

class CoIdentity

    def initialize(v)
        @val = v
    end

    def extract
        val
    end

    def extend(&f)
        self.new(f.call(self))
    end
end

```

Extract takes a value out of a functor.

```ruby

CoIdentity.new(1).extract

```

Extend runs a function on the comonad. The function should return the same type as the comonad.

```ruby
CoIdentity.new(1).extend{|co| co.extract() + 1} #=> CoIdentity.new(2)

```

## Applicative Functor

An applicative functor is an object with an `ap` function. `ap` applies a function in the object to a value in another object of the same type.


```ruby

# Implementation

class Array
 def ap(xs)
   reduce([]) { |acc, f| acc.concat(xs.map(&f)) }
 end
end

# Usage
[ lambda { |a| a + 1 } ].ap([1]) #=> [2]

```

This is useful if you have multiple applicative functors and you want to apply a function that takes multiple arguments to them.

```ruby
arg_1 = [1, 3]
arg_2 = [4, 5]

# function needs to be curried for this to work
add = -> (x) { -> (y) { x + y } }

partially_applied_adds = [add].ap(arg_1)# => [#<Proc:0x00000004bffcf8@(irb):497 (lambda)>, #<Proc:0x00000004bffc80@(irb):497 (lambda)>] 

```

This gives you an array of functions that you can call `ap` on to get the result:

```ruby
partially_applied_adds.ap(arg_2) #=> [5, 6, 7, 8]

```

## Morphism

A transformation function.

## Isomorphism

A pair of transformations between 2 types of objects that is structural in nature and no data is lost.

For example, 2D coordinates could be stored as an array `[2,3]` or hash `{x: 2, y: 3}`.

```ruby
# Providing functions to convert in both directions makes them isomorphic.

pair_to_coords = -> (pair) { Hash(x: pair[0], y: pair[1]) }

coords_to_pair = -> (coords) { [coords[:x], coords[:y]] }

coords_to_pair.call(pair_to_coords.call([1, 2])) #=> [1, 2]

pair_to_coords.call(coords_to_pair.call({x: 1, y: 2})) #=> {:x=>1, :y=>2} 

```



## Setoid

An object that has an `equals` function which can be used to compare other objects of the same type.

Make array a setoid:

```ruby
[1, 2].eql? [1, 2] #=> true 
[1, 2].eql? [0] #=> false 

```

## Semigroup

An object that has a `concat` function that combines it with another object of the same type.

```ruby
[1].concat [2] #=> [1, 2] 

```

## Foldable

An object that has a `reduce` function that can transform that object into some other type.

```ruby
sum = ->(list) { list.reduce(0){ |acc, val| acc + val }}

sum.call([1, 2, 3]) #=> 6 
```

## Traversable

TODO

## Type Signatures

There's quite a bit of variance across the community but they often follow the following patterns:

```ruby
# TODO

```

If a function accepts another function as an argument it is wrapped in parentheses.

```ruby
# TODO
```

The letters `a`, `b`, `c`, `d` are used to signify that the argument can be of any type. The following version of `map` takes a function that transforms a value of some type `a` into another type `b`, an array of values of type `a`, and returns an array of values of type `b`.

```ruby
# TODO
```

### Further reading
* [Ramda's type signatures](https://github.com/ramda/ramda/wiki/Type-Signatures)
* [Mostly Adaquate Guide](https://drboolean.gitbooks.io/mostly-adequate-guide/content/ch7.html#whats-your-type)
* [What is Hindley-Milner?](http://stackoverflow.com/a/399392/22425) on Stack Overflow

## Union type
A union type is the combination of two types together into another one.

Union types are also known as algebraic types, tagged unions, or sum types.

There's a [couple](https://github.com/paldepind/union-type) [libraries](https://github.com/puffnfresh/daggy) in JS which help with defining and using union types.

## Product type

A **product** type combines types together in a way you're probably more familiar with:

```ruby
# TODO
```
It's called a product because the total possible values of the data structure is the product of the different values.

See also [Set theory](https://en.wikipedia.org/wiki/Set_theory).

## Option
Option is a [union type](#union-type) with two cases often called `Some` and `None`.

Option is useful for composing functions that might not return a value.

```ruby
#TODO
```
Use `chain` to sequence functions that return `Option`s
```ruby
#TODO
```
`Option` is also known as `Maybe`. `Some` is sometimes called `Just`. `None` is sometimes called `Nothing`.

---