# DuckPuncher

Currently have the following punches in our repertoire:

* Array#m   - alias for `map(&:)`, usage: `[1].m(:succ)`
* Array#get - usage: `[].methods.get('ty?') #=> [:empty?]`
* Hash#seek - usage: `{a: 1, b: {c: 2}}.seek(:b, :c) #=> 2`
* Numeric#to_currency - usage: `25.245.to_currency #=> '25.25'`
* Numeric#to_duration - usage `10_000.to_duration  #=> '2 h 46 min'` 
* Numeric#to_time_ago  - usage `10_000.to_time_ago  #=> '2 hours ago'`
* Numeric#to_rad      - usage `10.15.to_rad        #=> 0.17715091907742445`
* String#pluralize    - usage `'hour'.pluralize(2) #=> 'hours'`

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
