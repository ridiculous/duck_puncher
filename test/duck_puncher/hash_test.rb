require_relative '../test_helper'
DuckPuncher.punch! :Object

class HashTest < MiniTest::Test
  def test_dig
    my_hash = { a: 1, b: { c: 2 } }.punch
    assert_equal my_hash.dig(:a), 1
    assert_equal my_hash.dig(:b, :a), nil
    assert_equal my_hash.dig(:b, :c), 2
    assert_equal my_hash.dig(:b), { c: 2 }
  end
end
