# DuckPuncher

Currently have the following duck punches:

* Array#m   - alias for `map(&:)`, usage: `[1].m(:succ)`
* Hash#seek - usage: `{a: 1, b: {c: 2}}.seek(:b, :c) #=> 2`
* Numeric#to_currency - usage: `25.245.to_currency #=> '25.25'`
* Numeric#to_duration - usage `10_000.to_duration  #=> '2 h 46 min'` 
* Numeric#to_rad      - usage `10.15.to_rad        #=> 0.17715091907742445`

## Installation

Add this line to your application's Gemfile:

    gem 'duck_puncher'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install duck_puncher

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
