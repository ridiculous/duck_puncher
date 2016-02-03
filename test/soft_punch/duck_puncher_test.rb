require_relative '../test_helper'

class DuckPuncherTest < MiniTest::Test
  DuckString = DuckPuncher.punch :String
  DuckNumber, DuckArray = DuckPuncher.punch :Numeric, :Array

  def test_duck_string
    refute_respond_to '', :underscore
    assert_respond_to DuckString.new, :underscore
    refute_respond_to '', :underscore
  end

  def test_duck_number_array
    refute_respond_to 25, :to_currency
    refute_respond_to [], :m
    assert_respond_to DuckNumber.new, :to_currency
    assert_respond_to DuckArray.new, :m
    refute_respond_to 25, :to_currency
    refute_respond_to [], :m
  end

  def test_excluding_punches
    refute_respond_to Object.new, :punch
    DuckPuncher.punch! :Object, only: :punch
    assert_respond_to Object.new, :punch
    refute_respond_to Object.new, :require!
    DuckPuncher.punch! :Object, only: :require!
    assert_respond_to Object.new, :require!
  end
end
