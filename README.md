# DuckPuncher [![Gem Version](https://badge.fury.io/rb/duck_puncher.svg)](http://badge.fury.io/rb/duck_puncher)  [![Build Status](https://travis-ci.org/ridiculous/duck_puncher.svg)](https://travis-ci.org/ridiculous/duck_puncher) [![Code Climate](https://codeclimate.com/github/ridiculous/duck_puncher/badges/gpa.svg)](https://codeclimate.com/github/ridiculous/duck_puncher)

DuckPuncher provides an interface for administering __duck punches__ (a.k.a "monkey patches"). Punches can be applied permanently via an extension
or temporarily as a decorator. Decorator classes are generated when an extension is registered and used via `Object#punch`. The object is wrapped
in one decorator for each of the object's ancestors (with registered punches) and behaves much like it's extended cousin, `Object.punch!`.

## Install

```ruby
gem 'duck_puncher', '~> 4.3'
```

## Usage

Punch all registered ducks:

```ruby
DuckPuncher.()
```

Punch individual ducks by name:

```ruby
DuckPuncher.(Hash, Object)
```

Add `punch` as a proxy method to all punches:

```ruby
DuckPuncher.(Object, only: :punch)
```

Redirect the punches registered for a class to another target:

```ruby
DuckPuncher.(Object, target: String)
```

### Tactical punches

`DuckPuncher` extends the amazing [Usable](https://github.com/ridiculous/usable) gem, so you can configure only the punches you want! For instance:

```ruby
DuckPuncher.(Numeric, only: [:to_currency, :to_duration])
```

If you punch `Object` then you can use `#punch!` on any object to extend individual instances:

```ruby
>> DuckPuncher.(Object, only: :punch!)
>> %w[yes no 1].punch!.m!(:punch).m(:to_boolean)
=> [true, false, true]
```

Alternatively, there is also the `Object#punch` method which returns a decorated copy of an object with punches mixed in:
```ruby
>> DuckPuncher.(Object, only: :punch)
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
>> DuckPuncher.(Object, only: [:punch, :punch!])
>> def soft_punch() ('a'..'z').punch.echo(1).map(&:upcase) end
>> def hard_punch() ('a'..'z').punch!.echo(1).mm(:*, 3) end
>> soft_punch
"a".."z"
* /.../delegate.rb:85:in `method_missing'
=> ["A", "B", "C", "D", "E", "F", "G", "H", "I", ...]
>> hard_punch
"a".."z"
* (irb):11:in `hard_punch'
=> ["AAA", "BBB", "CCC", "DDDD", ...]
```

## Default extensions

#### Enumerable (including Array, Set, Range, and Enumerator)
```ruby
[].m(:to_s)
[].m!(:upcase)
[].mm(:sub, /[aeiou]/, '*')
[].mm!(:sub, /[aeiou]/, '*')
[].except(:foo, :bar, :baz)
[].map_keys(:id)
```

#### Hash
```ruby
{ a: 1, b: { c: 2 }}.dig(:b, :c)  # => 2
                                  # ii Standard in Ruby >= 2.3
{ a: 1, b: nil }.compact          # => {a: 1}
                                  # !! destructive
```

#### Numeric
```ruby
25.245.to_currency # => "25.25"
10_000.to_duration # => "2 h 46 min"
10_000.to_time_ago # => "2 hours ago"
10.15.to_rad       # => "0.17715091907742445"
```

#### String
```ruby
'hour'.pluralize(2)           # => "hours"
'DJ::JSONStorage'.underscore  # => "dj/json_storage"
'true'.to_boolean             # => "true"
'MiniTest::Test'.constantize  # => MiniTest::Test
```

#### Module
```ruby
Kernel.local_methods  # => methods defined directly in the class + nested constants w/ methods
```

#### Object
```ruby
Object.new.clone!  # => a deep clone of the object (using Marshal.dump)
Object.new.punch   # => a copy of Object.new with String punches mixed in
Object.new.punch!  # => destructive version applies extensions directly to the base object
Object.new.echo    # => prints and returns itself. Accepts a number,
                   #    indicating how many lines of the trace to display
Object.new.track   # => Trace methods calls to the object
                   # !! requires [object_tracker](https://github.com/ridiculous/object_tracker), which it'll try to download
```

#### Method
```ruby
require 'benchmark'

Benchmark.method(:measure).to_instruct # => the Ruby VM instruction sequence for the method
Benchmark.method(:measure).to_source   # => the method definition as a string
```

## Registering custom punches

DuckPuncher allows you to utilize the `punch` and `punch!` interface to __decorate__ or __extend__, respectively, any object with your own punches. Simply 
call `DuckPuncher.register` with the name of your module (or an array of names) and any of
[these options](https://github.com/ridiculous/duck_puncher/blob/master/lib/duck_puncher/duck.rb#L10).


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
DuckPuncher.(Object, only: :punch)

# Usage
user = User.new('Ryan').punch
user.call_with_retry(19.99)
```

To register the extension _and_ punch the class, use `DuckPuncher.register!`

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
>> DuckPuncher.(Object, only: :require!)
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
DuckPuncher.(:Object, only: :track)
Donald.track
Duck.track
>> Duck.usable Donald, only: :tap_tap
# =>  * called "Donald.respond_to?" with to_str, true [RUBY CORE] (0.00002)
# =>  * called "Donald.respond_to?" with to_str, true [RUBY CORE] (0.00001)
# =>  * called "Donald.respond_to?" with to_ary, true [RUBY CORE] (0.00001)
# =>  * called "Donald.to_s" [RUBY CORE] (0.00001)
# =>  * called "Duck.usable_config" [ruby-2.3.0@duck_puncher/gems/usable-1.2.0/lib/usable.rb:10] (0.00002)
# =>  * called "Duck.usable_config" [ruby-2.3.0@duck_puncher/gems/usable-1.2.0/lib/usable.rb:10] (0.00001)
# =>  * called "Donald.const_defined?" with UsableSpec [RUBY CORE] (0.00001)
# =>  * called "Donald.dup" [RUBY CORE] (0.00002)
# =>  * called "Donald.name" [RUBY CORE] (0.00000)
# =>  * called "Donald.instance_methods" [RUBY CORE] (0.00001)
# =>  * called "Duck.const_defined?" with DonaldUsed [RUBY CORE] (0.00001)
# =>  ...
```

## Contributing

* Fork it
* Run tests with `rake`
* Start an IRB console that already has all your ducks in a row: `bin/console`
* Start an IRB console without punching ducks: `PUNCH=no bin/console`
* Make changes and submit a PR to [https://github.com/ridiculous/duck_puncher](https://github.com/ridiculous/duck_puncher)

## License

MIT
