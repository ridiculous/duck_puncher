require 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
require 'duck_puncher'
require_relative 'fixtures/test_classes'

Minitest::Reporters.use!

DuckPuncher.logger.level = Logger::DEBUG
