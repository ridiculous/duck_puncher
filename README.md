# DuckPuncher

These are the ducks I can punch:

    Array#m             => alias for `map(&:)`, usage: `[1].m(:succ)`
    Array#get           => usage: `[].methods.get('ty?') #=> [:empty?]`
    Hash#seek           => usage: `{a: 1, b: {c: 2}}.seek(:b, :c) #=> 2`
    Numeric#to_currency => usage: `25.245.to_currency` formats a number in currency (e.g. '25.25' or '1.00') 
    Numeric#to_duration => usage `10_000.to_duration` turns a number into duration (e.g. '2 h 46 min')
    Numeric#to_time_ago => usage `10_000.to_time_ago` turns a number into time ago (e.g. '2 hours ago')
    Numeric#to_rad      => usage `10.15.to_rad` returns 0.17715091907742445
    String#pluralize    => usage `'hour'.pluralize(2)` turns "hour" into "hours"
    Object#clone!       => usage `Object.new.clone!` makes a deep clone of the object (using Marshal)

## Install

    gem 'duck_puncher'

## Usage

Ducks need to be _loaded_ before they can be punched! Maybe do this in an initializer?

    DuckPuncher.punch! :Hash, :Object #=> only punches the specified ducks
    DuckPuncher.punch_all!            #=> punches all the ducks
