# DuckPuncher [![Gem Version](https://badge.fury.io/rb/duck_puncher.svg)](http://badge.fury.io/rb/duck_puncher)  [![Build Status](https://travis-ci.org/ridiculous/duck_puncher.svg)](https://travis-ci.org/ridiculous/duck_puncher) [![Code Climate](https://codeclimate.com/github/ridiculous/duck_puncher/badges/gpa.svg)](https://codeclimate.com/github/ridiculous/duck_puncher)

DuckPuncher provides an interface for administering __duck punches__ (a.k.a "monkey patches"). Punches can be administered in several ways: 

* as an extension to the class
* as a subclass
* as a decorator

Default extensions:

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
        #punch        => `'duck'.punch` => a copy of 'duck' with String punches mixed in
Method  #to_instruct  => `Benchmark.method(:measure).to_instruct` returns the Ruby VM instruction sequence for the method
        #to_source    => `Benchmark.method(:measure).to_source` returns the method definition as a string
```

## Tactical punches

Punch only certain methods onto a duck:

```ruby
>> DuckPuncher.punch! :Numeric, only: [:to_currency, :to_duration]
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

```ruby
DuckPuncher.punch_all!                   # => punches all registered ducks
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
`.register` with the name of your module.

### Punching your own duck
```ruby
class User < Struct.new(:name)
end

module Billable
  def call(amt)
    puts "Attempting to bill #{name} for $#{amt}"
    fail Errno::ENOENT
  end
end

module Retryable
  def call_with_retry(*args, retries: 3)
    call *args
  rescue Errno::ENOENT
    puts 'retrying'
    retry if (retries -= 1) > 0
  end
end

DuckPuncher.register :Billable
DuckPuncher.register :Retryable
DuckPuncher.punch! :Object, only: :punch

user = User.new('Ryan').punch(:Billable).punch(:Retryable)
user.call_with_retry(19.99)
```

### Punching core ducks
```ruby
# Example punches
module Donald
  def tap_tap
    p self
    self
  end
end

module Daisy
  def quack
    "Hi, I'm Daisy"
  end
end
```

When punching a class, the `:class` option is required when registering:

```ruby
DuckPuncher.register :Donald, class: 'Array'
DuckPuncher.punch! :Donald
[].tap_tap
```

When punching instances, the `:class` option can be omitted, but the name of the punch is required:

```ruby
DuckPuncher.punch! :Object, only: :punch
DuckPuncher.register :Donald
DuckPuncher.register :Daisy
ducks = [].punch(:Donald).punch(:Daisy)
ducks.tap_tap
ducks.quack
```

The `register` method takes the same options as [Duck#initialize](https://github.com/ridiculous/duck_puncher/blob/master/lib/duck_puncher/duck.rb#L11)
and will be used to configure punches.

## Experimental

__Object#require!__ will try to require a gem, or, if it's not found, then _download_ it! It will also keep track of any
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

__Object#track__ builds upon `require!` to download the [ObjectTracker](https://github.com/ridiculous/object_tracker) gem,
if it's not available in the current load path, and starts tracking the current object!

```ruby
Duck = Class.new
Donald = Module.new { def tap_tap() self end }
DuckPuncher.punch!(:Object, only: :track)
Donald.track
Duck.track
>> Duck.usable Donald, only: :tap_tap
  * called "Donald.respond_to?" with to_str, true [RUBY CORE] (0.00002)
  * called "Donald.respond_to?" with to_str, true [RUBY CORE] (0.00001)
  * called "Donald.respond_to?" with to_ary, true [RUBY CORE] (0.00001)
  * called "Donald.to_s" [RUBY CORE] (0.00001)
  * called "Duck.usable_config" [ruby-2.3.0@duck_puncher/gems/usable-1.2.0/lib/usable.rb:10] (0.00002)
  * called "Duck.usable_config" [ruby-2.3.0@duck_puncher/gems/usable-1.2.0/lib/usable.rb:10] (0.00001)
  * called "Donald.const_defined?" with UsableSpec [RUBY CORE] (0.00001)
  * called "Donald.dup" [RUBY CORE] (0.00002)
  * called "Donald.name" [RUBY CORE] (0.00000)
  * called "Donald.instance_methods" [RUBY CORE] (0.00001)
  * called "Duck.const_defined?" with DonaldUsed [RUBY CORE] (0.00001)
  * called "Donald.respond_to?" with to_str, true [RUBY CORE] (0.00001)
  * called "Donald.respond_to?" with to_str, true [RUBY CORE] (0.00000)
  * called "Donald.respond_to?" with to_ary, true [RUBY CORE] (0.00000)
  * called "Donald.to_s" [RUBY CORE] (0.00035)
  * called "Duck.const_set" with DonaldUsed, #<Module:0x007fe23a261618> [RUBY CORE] (0.00002)
  * called "Duck.usable_config" [ruby-2.3.0@duck_puncher/gems/usable-1.2.0/lib/usable.rb:10] (0.00000)
  * called "Donald.respond_to?" with to_str, true [RUBY CORE] (0.00000)
  * called "Donald.respond_to?" with to_ary, true [RUBY CORE] (0.00001)
  * called "Donald.to_s" [RUBY CORE] (0.00019)
  * called "Donald.respond_to?" with to_str, true [RUBY CORE] (0.00001)
  * called "Donald.respond_to?" with to_str, true [RUBY CORE] (0.00000)
  * called "Donald.respond_to?" with to_ary, true [RUBY CORE] (0.00000)
  * called "Donald.to_s" [RUBY CORE] (0.00000)
  * called "Duck.include" with Duck::DonaldUsed [RUBY CORE] (0.00001)
  * called "Duck#send" with include, Duck::DonaldUsed [RUBY CORE] (0.00024)
  * called "Duck.usable!" with #<Usable::ModExtender:0x007fe23a261ca8> [ruby-2.3.0@duck_puncher/gems/usable-1.2.0/lib/usable.rb:41] (0.00143)
  * called "Donald.const_defined?" with UsableSpec [RUBY CORE] (0.00001)
  * called "Duck.usable" with Donald, {:only=>:tap_tap} [ruby-2.3.0@duck_puncher/gems/usable-1.2.0/lib/usable.rb:30] (0.00189)
  # ... You get the idea.
```

## Contributing

* Fork it
* Run tests with `rake`
* Start an IRB console that already has all your ducks in a row: `bin/console`
* Start an IRB console without punching ducks: `PUNCH=no bin/console`
* Make changes and submit a PR to [https://github.com/ridiculous/duck_puncher](https://github.com/ridiculous/duck_puncher)

## License

MIT
