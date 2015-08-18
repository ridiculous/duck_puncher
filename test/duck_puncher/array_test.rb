require_relative '../test_helper'

class ArrayTest < MiniTest::Test
  def test_m
    samples = ('a'..'m').to_a
    assert_equal samples.map(&:upcase), samples.m(:upcase)
  end

  def test_get
    assert_equal [].methods.get(/ty\?/), [:empty?]
    assert_equal [].methods.get('ty?'), [:empty?]
  end
end
