# DuckPuncher

Ruby objects walk and talk like ducks, therefore they _are_ ducks. But ducks don't always behave, and some times they need
tough love. You know, lil love punches! :punch: :heart:

These are the ducks I love the most:

```ruby
Array#m             => `[].m(:to_s)` => `[].map(&:to_s)` 
Array#mm            => `[].mm(:sub, /[aeiou]/, '*')` => `[].map { |x| x.sub(/[aeiou]/, '*') }` 
Array#get           => `[].methods.get('ty?')` => [:empty?] 
Hash#dig            => `{a: 1, b: {c: 2}}.dig(:b, :c)` => 2 (Part of standard lib in Ruby >= 2.3)
Numeric#to_currency => `25.245.to_currency` => 25.25 
Numeric#to_duration => `10_000.to_duration` => '2 h 46 min'
Numeric#to_time_ago => `10_000.to_time_ago` => '2 hours ago'
Numeric#to_rad      => `10.15.to_rad` => 0.17715091907742445
String#pluralize    => `'hour'.pluralize(2)` => "hours"
String#underscore   => `'DuckPuncher::JSONStorage'.underscore` => 'duck_puncher/json_storage'
Object#clone!       => `Object.new.clone!` => a deep clone of the object (using Marshal.dump)
Object#punch        => `'duck'.punch` => a copy of 'duck' with the mixed String punches
Object#track        => `'duck'.punch.track` => downloads the [ObjectTracker](https://github.com/ridiculous/object_tracker) gem if it's not available and starts tracking this object
Method#to_instruct  => `Benchmark.method(:measure).to_instruct` returns the Ruby VM instruction sequence for the method
Method#to_source    => `Benchmark.method(:measure).to_source` returns the method definition as a string
```

## Tactical punches

Sometimes you don't want to punch all the ducks. That's why you can punch only certain methods onto a class:

```ruby
>> DuckPuncher.punch! :Numeric, only: [:to_currency, :to_duration]
INFO: Already punched Numeric
=> nil
>> 100.to_currency '$'
=> "$100.00"
>> 100.to_duration
=> "1 min"
>> 100.to_time_ago
NoMethodError: undefined method `to_time_ago' for 100:Fixnum
```

There is also an experimental punch that tries to download the required gem if it doesn't exist on your computer. The
method is called `require!` and works like this:

Downloads and activates a gem for the current and subsequent consoles. For example:

```bash
>> `require 'pry'` 
LoadError: cannot load such file -- pry
 from (irb):1:in `require'
 from (irb):1
 from bin/console:10:in `<main>'
>> require! 'pry'
Fetching: method_source-0.8.2.gem (100%)
Fetching: slop-3.6.0.gem (100%)
Fetching: coderay-1.1.0.gem (100%)
Fetching: pry-0.10.3.gem (100%)
=> true
>> Pry.start
[1] pry(main)>
```

Pretty cool, right? Although, it doesn't work well with bigger gems or those with native extensions.

## Install

    gem 'duck_puncher'

## Usage

Ducks need to be _loaded_ before they can be punched! Maybe put this in an initializer:

```ruby
# config/initializers/duck_puncher.rb
DuckPuncher.punch_all!                   #=> punches all the ducks forever
DuckPuncher.punch! :Hash, :Object        #=> only punches the Hash and Object ducks
DuckPuncher.punch! :Object, only: :punch #=> only opens a can of whoop ass! Define one method to rule them all
```

Create a new class of your favorite duck pre-punched:

```ruby
DuckPuncher.punch :String               #=> returns an anonymous punched duck that inherits from String
DuckString = DuckPuncher.punch :String  #=> give the anonymous duck a name, so that you can use it!
DuckString.new.respond_to? :underscore  #=> true
```

If you punch `Object` then you can use `punch` on any object to get a new decorated copy of the class with the desired
functionality mixed in:

```ruby
# Assuming you've already done `DuckPuncher.punch! :Object, only: :punch`
%w[yes no 1].punch.m(:punch).punch.m(:to_boolean) #=> [true, false, true]
```

Because `DuckPuncher` extends the amazing [Usable](https://github.com/ridiculous/usable) gem, you can configure only the punches you want! 

## Contributing

* Fork it
* Run tests with `rake`
* Start an IRB console that already has all your ducks in a row `bin/console`
* Make changes and submit a PR to [https://github.com/ridiculous/duck_puncher](https://github.com/ridiculous/duck_puncher)
