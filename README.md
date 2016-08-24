# DuckPuncher [![Gem Version](https://badge.fury.io/rb/duck_puncher.svg)](http://badge.fury.io/rb/duck_puncher)  [![Build Status](https://travis-ci.org/ridiculous/duck_puncher.svg)](https://travis-ci.org/ridiculous/duck_puncher) [![Code Climate](https://codeclimate.com/github/ridiculous/duck_puncher/badges/gpa.svg)](https://codeclimate.com/github/ridiculous/duck_puncher)

DuckPuncher provides an interface for administering __duck punches__ (a.k.a "monkey patches"). Punches can be administered in several ways: 

* as an extension
* as a decorator

Default extensions:

```ruby
Enumerable
        #m                  => `[].m(:to_s)` => `[].map(&:to_s)`
        #m!                 => `[].m!(:upcase)` => `[].map!(&:upcase)`
        #mm                 => `[].mm(:sub, /[aeiou]/, '*')` => `[].map { |x| x.sub(/[aeiou]/, '*') }` 
        #mm!                => `[].mm!(:sub, /[aeiou]/, '*')` => `[].map! { |x| x.sub(/[aeiou]/, '*') }` 
        #except             => `[].except('foo', 'bar')` => `[] - ['foo', 'bar']`
        #map_keys           => `[{id: 1, name: 'foo'}, {id: 2}].map_keys(:id)` => `[1, 2]`
Hash
        #dig                => `{a: 1, b: {c: 2}}.dig(:b, :c)` => 2 (Part of standard lib in Ruby >= 2.3)
        #compact            => `{a: 1, b: nil}.compact` => {a: 1}
Numeric
        #to_currency        => `25.245.to_currency` => 25.25 
        #to_duration        => `10_000.to_duration` => '2 h 46 min'
        #to_time_ago        => `10_000.to_time_ago` => '2 hours ago'
        #to_rad             => `10.15.to_rad` => 0.17715091907742445
String
        #pluralize          => `'hour'.pluralize(2)` => "hours"
        #underscore         => `'DuckPuncher::JSONStorage'.underscore` => 'duck_puncher/json_storage'
        #to_boolean         => `'1'.to_boolean` => true
        #constantize        => `'MiniTest::Test'.constantize` => MiniTest::Test
Module
        #local_methods      => `Kernel.local_methods` returns the methods defined directly in the class + nested constants w/ methods
Object
        #clone!             => `Object.new.clone!` => a deep clone of the object (using Marshal.dump)
        #punch              => `'duck'.punch` => a copy of 'duck' with String punches mixed in
        #punch!             => `'duck'.punch!` => destructive version applies extensions directly to the base object
        #echo               => `'duck'.echo.upcase` => spits out the caller and value of the object and returns the object
        #track              => `Object.new.track` => Traces methods calls to the object (requires [object_tracker](https://github.com/ridiculous/object_tracker), which it'll try to download)
Method
        #to_instruct        => `Benchmark.method(:measure).to_instruct` returns the Ruby VM instruction sequence for the method
        #to_source          => `Benchmark.method(:measure).to_source` returns the method definition as a string
```

## Usage

Punch all registered ducks:

```ruby
DuckPuncher.punch_all!
```

Punch individual ducks by name:

```ruby
DuckPuncher.punch! Hash, Object
```

One method to rule them all:

```ruby
DuckPuncher.punch! Object, only: :punch 
```

### Tactical punches

`DuckPuncher` extends the amazing [Usable](https://github.com/ridiculous/usable) gem, so you can configure only the punches you want! For instance:

```ruby
DuckPuncher.punch! Numeric, only: [:to_currency, :to_duration]
```

If you punch `Object` then you can use `#punch!` on any object to extend individual instances:

```ruby
>> DuckPuncher.punch! Object, only: :punch!
>> %w[yes no 1].punch!.m!(:punch).m(:to_boolean)
=> [true, false, true]
```

Alternatively, there is also the `Object#punch` method which returns a decorated copy of an object with punches mixed in:
```ruby
>> DuckPuncher.punch! Object, only: :punch
>> %w[1 2 3].punch.m(:to_i)
=> [1, 2, 3]
```

The `#punch!` method will lookup the extension by the object's class name. The above example works because `Array` and `String` are default extensions. If you want to punch a specific extension, then you can specify it as an argument:
```ruby
>> LovableDuck = Module.new { def inspect() "I love #{self.first}" end }
>> DuckPuncher.register Array, LovableDuck
>> ducks = %w[ducks]
>> soft_punch = ducks.punch
=> "I love ducks"
>> soft_punch.class
=> DuckPuncher::ArrayDelegator
>> ducks.punch!.class
=> Array
```

When there are no punches registered for a class, it'll search the ancestor list for a class with registered punches. For example, `Array` doesn't have
a method defined `echo`, but when we punch `Object`, it means all subclasses have access to the same methods, even with soft punches.

```ruby
def soft_punch
  ('a'..'z').punch.echo.to_a.map(&:upcase)
end

def hard_punch
  ('a'..'z').to_a.punch!.m!(:upcase).mm!(:*, 3).echo
end

>> soft_punch
"a..z -- (irb):8:in `soft_punch'"
=> ["A", "B", "C", "D", ...]
>> hard_punch
"[\"AAA\", \"BBB\", \"CCC\", \"DDD\", ...] -- (irb):12:in `hard_punch'"
=> ["AAA", "BBB", "CCC", "DDDD", ...]
```

### Registering custom punches

DuckPuncher allows you to utilize the `punch` interface to __extend__ any kind of object with your own punches. Simply 
call `DuckPuncher.register` with the name of your module (or an array of names) and any of
[these options](https://github.com/ridiculous/duck_puncher/blob/master/lib/duck_puncher/duck.rb#L11).


```ruby
# Define some extensions
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
```

```ruby
# Our duck
class User < Struct.new(:name)
end

# Register the extensions
DuckPuncher.register User, :Billable, :Retryable

# Add the #punch method to User instances
DuckPuncher.punch! Object, only: :punch

# Usage
user = User.new('Ryan').punch
user.call_with_retry(19.99)
```

## Install

```ruby
gem 'duck_puncher'
```

## Logging

Get notified of all punches/extensions by changing the logger level:

```ruby
DuckPuncher.logger.level = Logger::INFO
```

The default log level is `DEBUG`

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
>> DuckPuncher.punch! Object, only: :require!
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
