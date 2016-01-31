require_relative '../test_helper'

class DuckPuncherTest < MiniTest::Test
  DuckString = DuckPuncher.punch :String
  DuckNumber, DuckArray = DuckPuncher.punch :Numeric, :Array

  def test_punch
    refute_respond_to '', :underscore
    assert_respond_to DuckString.new, :underscore
    refute_respond_to '', :underscore
  end

  def test_punch_multiple
    refute_respond_to 25, :to_currency
    refute_respond_to [], :m
    assert_respond_to DuckNumber.new, :to_currency
    assert_respond_to DuckArray.new, :m
    refute_respond_to 25, :to_currency
    refute_respond_to [], :m
  end
end
