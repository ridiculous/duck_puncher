require 'minitest/autorun'
require 'duck_puncher'

class NumericTest < MiniTest::Unit::TestCase
  def test_to_currency
    assert_equal '0.00', 0.to_currency
    assert_equal '25.00', 25.to_currency
    assert_equal '25.20', 25.2.to_currency
    assert_equal '25.25', 25.245.to_currency
  end

  def test_to_duration
    assert_equal '', 10.to_duration
    assert_equal '1 min', 100.to_duration
    assert_equal '16 min', 1_000.to_duration
    assert_equal '2 h 46 min', 10_000.to_duration
    assert_equal '27 h 46 min', 100_000.to_duration
  end

  def test_to_duration_with_seconds
    assert_equal '10 s', 10.to_duration(true)
    assert_equal '1 min 40 s', 100.to_duration(true)
    assert_equal '16 min 40 s', 1_000.to_duration(true)
    assert_equal '2 h 46 min', 10_000.to_duration(true)
  end
end