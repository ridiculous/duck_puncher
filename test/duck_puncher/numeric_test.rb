require 'minitest/autorun'
require 'duck_puncher'

class NumericTest < MiniTest::Unit::TestCase
  def test_to_currency
    assert_equal '0.00', 0.to_currency
    assert_equal '25.00', 25.to_currency
    assert_equal '25.20', 25.2.to_currency
    assert_equal '25.25', 25.245.to_currency
  end
end