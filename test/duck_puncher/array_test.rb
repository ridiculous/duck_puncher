require 'minitest/autorun'
require 'duck_puncher'

class ArrayTest < MiniTest::Unit::TestCase
  def test_m
    samples = ('a'..'m').to_a
    assert_equal samples.map(&:upcase), samples.m(:upcase)
  end
end