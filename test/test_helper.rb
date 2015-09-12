require 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
require 'duck_puncher'

Minitest::Reporters.use!
DuckPuncher.punch_all!
