# DuckPuncher

These are the ducks I can punch:

    Array#m             => `[].m(:to_s)` => `[].map(&:to_s)` 
    Array#mm            => `[].mm(:sub, /[aeiou]/, '*')` => `[].map { |x| x.sub(/[aeiou]/, '*') }` 
    Array#get           => `[].methods.get('ty?')` => [:empty?] 
    Hash#seek           => `{a: 1, b: {c: 2}}.seek(:b, :c)` => 2
    Numeric#to_currency => `25.245.to_currency` => 25.25 
    Numeric#to_duration => `10_000.to_duration` => '2 h 46 min'
    Numeric#to_time_ago => `10_000.to_time_ago` => '2 hours ago'
    Numeric#to_rad      => `10.15.to_rad` => 0.17715091907742445
    String#pluralize    => `'hour'.pluralize(2)` => "hours"
    String#underscore   => `'DuckPuncher::JSONStorage'.underscore` => 'duck_puncher/json_storage'
    Object#clone!       => `Object.new.clone!` => a deep clone of the object (using Marshal.dump)
    Method#to_instruct  => `Benchmark.method(:measure).to_instruct` returns the Ruby VM instruction sequence for the method
    Method#to_source    => `Benchmark.method(:measure).to_source` returns the method definition as a string
    
I also provide an experimental punch that tries to download the required gem if it doesn't exist on your computer. The
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

Try it out if your feeling frisky! However, I noticed it doesn't work well with bigger gems and those with native extensions.

## Install

    gem 'duck_puncher'

## Usage

Ducks need to be _loaded_ before they can be punched! Maybe do this in an initializer?

```ruby
DuckPuncher.punch! :Hash, :Object #=> only punches the specified ducks
DuckPuncher.punch_all!            #=> punches all the ducks
```

## Contributing

* Fork it
* Run tests with `rake`
* Start an IRB console that already has all your ducks in a row `bin/console`
* Make changes and submit a PR to [https://github.com/ridiculous/duck_puncher](https://github.com/ridiculous/duck_puncher)
