# DuckPuncher [![Gem Version](https://badge.fury.io/rb/duck_puncher.svg)](http://badge.fury.io/rb/duck_puncher)  [![Build Status](https://travis-ci.org/ridiculous/duck_puncher.svg)](https://travis-ci.org/ridiculous/duck_puncher) [![Code Climate](https://codeclimate.com/github/ridiculous/duck_puncher/badges/gpa.svg)](https://codeclimate.com/github/ridiculous/duck_puncher)

Since Ruby objects walk and talk like ducks, they must therefore _be_ ducks. But ducks don't always behave, and some times they need
tough love! :punch: :heart:

These are the ducks I love the most:

```ruby
Array   #m            => `[].m(:to_s)` => `[].map(&:to_s)` 
        #mm           => `[].mm(:sub, /[aeiou]/, '*')` => `[].map { |x| x.sub(/[aeiou]/, '*') }` 
        #get          => `[].methods.get('ty?')` => [:empty?] 
Hash    #dig          => `{a: 1, b: {c: 2}}.dig(:b, :c)` => 2 (Part of standard lib in Ruby >= 2.3)
Numeric #to_currency  => `25.245.to_currency` => 25.25 
        #to_duration  => `10_000.to_duration` => '2 h 46 min'
        #to_time_ago  => `10_000.to_time_ago` => '2 hours ago'
        #to_rad       => `10.15.to_rad` => 0.17715091907742445
String  #pluralize    => `'hour'.pluralize(2)` => "hours"
        #underscore   => `'DuckPuncher::JSONStorage'.underscore` => 'duck_puncher/json_storage'
Object  #clone!       => `Object.new.clone!` => a deep clone of the object (using Marshal.dump)
        #punch        => `'duck'.punch` => a copy of 'duck' with the mixed String punches
        #track        => `'duck'.punch.track` => downloads the [ObjectTracker](https://github.com/ridiculous/object_tracker) gem if it's not available and starts tracking this object
Method  #to_instruct  => `Benchmark.method(:measure).to_instruct` returns the Ruby VM instruction sequence for the method
        #to_source    => `Benchmark.method(:measure).to_source` returns the method definition as a string
```

## Tactical punches

Sometimes you don't want to punch all the ducks. That's why you can punch only certain methods onto a class:

```ruby
>> DuckPuncher.punch! :Numeric, only: [:to_currency, :to_duration]
WARN: Punching [:to_currency, :to_duration] onto Numeric
=> nil
>> 100.to_currency '$'
=> "$100.00"
>> 100.to_duration
=> "1 min"
>> 100.to_time_ago
NoMethodError: undefined method `to_time_ago' for 100:Fixnum
```

## Install

    gem 'duck_puncher'

## Usage

Ducks need to be _loaded_ before they can be punched! Maybe put this in an initializer:

```ruby
# config/initializers/duck_puncher.rb
DuckPuncher.punch_all!                   # => punches all the ducks forever
DuckPuncher.punch! :Hash, :Object        # => only punches the Hash and Object ducks
DuckPuncher.punch! :Object, only: :punch # => only opens a can of whoop ass! Define one method to rule them all
```

The `.punch` method creates and caches a new punched class that inherits from the original. This avoids altering built-in
classes. For example:

```ruby
>> DuckPuncher.punch :String
=> DuckPuncher::StringDuck
>> DuckPuncher::StringDuck.new('Yes').to_boolean
=> true
>> String.new('Yes').respond_to? :to_boolean
=> false
```

If you punch `Object` then you can use `punch` on any object to get a new decorated copy of the class with the desired
functionality mixed in:

```ruby
>> DuckPuncher.punch! :Object, only: :punch
>> %w[yes no 1].punch.m(:punch).punch.m(:to_boolean)
=> [true, false, true]
```

Because `DuckPuncher` extends the amazing [Usable](https://github.com/ridiculous/usable) gem, you can configure only the punches you want! 

## Registering custom punches

DuckPuncher allows you to utilize the `punch` interface to decorate any kind of object with your own punches. Simply call 
`.register` with the name of your module:

```ruby
module Donald
  def tap_tap
    p self
    self
  end
end

DuckPuncher.register :Donald, class: 'Array', if: -> { !defined?(::Rails) || Rails.env.development? } 
```

The register method takes the same options as [Duck#initialize](https://github.com/ridiculous/duck_puncher/blob/master/lib/duck_puncher/duck.rb#L11)
and will be used to configure punches.

Activate a custom punch:

```ruby
DuckPuncher.punch! :Donald
[].tap_tap
# or
DuckPuncher.punch! :Object, only: :punch
[].punch(:Donald).tap_tap
```

## Experimental

__Object#require__ will try to require a gem, or, if it's not found, then _download_ it! It will also keep track of any
downloaded gems and load them for subsequent IRB/rails console sessions. Gems are _not_ 
saved to the Gemfile.

In the wild:

```bash
>> `require 'pry'` 
LoadError: cannot load such file -- pry
 from (irb):1:in `require'
 from (irb):1
 from bin/console:10:in `<main>'
>> DuckPuncher.punch! :Object, only: :require!
WARN: Punching require! onto Object
=> nil
>> require! 'pry'
Fetching: method_source-0.8.2.gem (100%)
Fetching: slop-3.6.0.gem (100%)
Fetching: coderay-1.1.0.gem (100%)
Fetching: pry-0.10.3.gem (100%)
=> true
>> Pry.start
[1] pry(main)>
```

Perfect! Mostly ... although, it doesn't work well with bigger gems or those with native extensions ¯\\\_(ツ)_/¯

## Contributing

* Fork it
* Run tests with `rake`
* Start an IRB console that already has all your ducks in a row `bin/console`
* Make changes and submit a PR to [https://github.com/ridiculous/duck_puncher](https://github.com/ridiculous/duck_puncher)
