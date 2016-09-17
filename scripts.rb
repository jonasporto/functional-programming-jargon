# arity
sum = ->(a, b) { a + b }
puts sum.arity #=> 2

# The arity of sum is 2

# Higher-Order Functions (HOF)
filter = lambda do |pred, xs|
	result = []
	xs.each_with_index do |_, idx|
		result << xs[idx] if pred.call(xs[idx])
	end
	result
end

is = lambda do |type|
	->(x) { x.instance_of? type }
end

filter.call(is.call(Fixnum), [0, '1', 2, nil]) #=> [0, 2]

# Partial Application

partial = lambda do |f, *args|
	->(*moreArgs) { f.call *(args + moreArgs) }
end

add3 = ->(a, b, c) { a + b + c }

fivePlus = partial.call(add3, 2, 3)
fivePlus.call(4) #=> 9

# Currying

sum = ->(a, b) { a + b }

curriedSum = lambda do |a|
	->(b) { a + b }
end

curriedSum.call(40).call(2) #=> 42


add2 = curriedSum.call(2)
add2.call(10) #=> 12

#Function Composition

compose = lambda do |f, &g|
	-> (a) { f.call g.call(a) }
end

floor_and_to_string = compose.call(->(val) { val.to_s }, &:floor)
floor_and_to_string.call(121.212121) #=> "121"

#Purity

greet = ->(name) { 'Hi, ' + name }
greet.call 'Brianne' #=> "Hi, Brianne"

name = 'Brianne'
greet = -> { greeting = 'Hi, ' + name }

greet.call #=> "Hi, Brianne"

# Side Effects

require 'date'

different_every_time = Date.new

puts 'IO is a side effect!'

# Idempotent

# f(f(x)) == f(x)

10.abs.abs #=> 10

[2, 1].sort.sort.sort #> [1, 2]

# Point-Free Style

map = lambda do |fn|
	->(list) { list.map &fn }
end

add = lambda do |a|
	->(b) { a + b }
end

increment_all = ->(numbers) { map.call(add.call(1)).call numbers }
increment_all.call([1, 2, 3, 4]) #=> [2, 3, 4, 5]

increment_all_2 = map.call(add.call(1))
increment_all_2.call([1, 2, 3, 4]) #=> [2, 3, 4, 5]

# Predicate
predicate = ->(a) { a > 2 }
[1, 2, 3, 4].select &predicate #> [3, 4]

# Value
5
{name: 'John', age: 30}
->(a) { a }
[1]
nil

# Constant
#¬¬ 


# Functor

object = [Object.new]

# preserves identity
object.map{ |x| x} === object #=> true

g = ->(x) { x }
f = ->(y) { y }

# composable
object.map{ |x| f.call(g.call(x)) } === object.map(&g).map(&f) #=> true


f = ->(x) { x + 1 }
g = ->(x) { x * 2 }

[1, 2, 3].map{|x| f.call(g.call(x)) } #=> [3, 5, 7]
[1, 2, 3].map(&g).map(&f)  #=> [3, 5, 7]

# Lift
# ¬¬

# Referential Transparency
greet = -> { 'Hello World!' }

# Equational Reasoning

# Lambda
-> (a) { a + 1 }

lambda do |a|
	a + 1 
end

[1, 2].map(&->(a) { a + 1 }) #=> [2, 3]
[1, 2].map{ |a| a + 1 } #=> [2, 3]


# assign lambda to a variable
add1 = ->(a) { a + 1 }

# Lazy evaluation

rand = lambda do 
	Enumerator.new do |enum|
		enum.yield Random.rand while 1 < 2
	end
end

rand_iter = rand.call
rand_iter.next #=> Each execution gives a random value, expression is evaluated on need.