# DuckPuncher

These are the ducks I can punch:

    Array#m             => `[].m(:to_s)` alias for `[].map(&:to_s)` 
    Array#mm            => `[].mm(:sub, /[aeiou]/, '*')` alias for `[].map { |x| x.sub(/[aeiou]/, '*') }` 
    Array#get           => `[].methods.get('ty?')` searches the array for a string matching the 'ty?' (e.g. [:empty?]) 
    Hash#seek           => `{a: 1, b: {c: 2}}.seek(:b, :c)` returns the value of nested hash keys (e.g. 2)
    Numeric#to_currency => `25.245.to_currency` formats a number in currency (e.g. '25.25' or '1.00') 
    Numeric#to_duration => `10_000.to_duration` turns a number into duration (e.g. '2 h 46 min')
    Numeric#to_time_ago => `10_000.to_time_ago` turns a number into time ago (e.g. '2 hours ago')
    Numeric#to_rad      => `10.15.to_rad` returns 0.17715091907742445
    String#pluralize    => `'hour'.pluralize(2)` turns "hour" into "hours"
    Object#clone!       => `Object.new.clone!` makes a deep clone of the object (using Marshal)
    Object#require!     => >> require 'pry'
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


## Install

    gem 'duck_puncher'

## Usage

Ducks need to be _loaded_ before they can be punched! Maybe do this in an initializer?

```ruby
DuckPuncher.punch! :Hash, :Object #=> only punches the specified ducks
DuckPuncher.punch_all!            #=> punches all the ducks
```
