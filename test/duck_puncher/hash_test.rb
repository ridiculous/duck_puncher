require_relative '../test_helper'

class HashTest < MiniTest::Test
  def test_seek
    my_hash = { a: 1, b: { c: 2 } }
    assert_equal my_hash.seek(:a), 1
    assert_equal my_hash.seek(:b, :a), nil
    assert_equal my_hash.seek(:b, :c), 2
    assert_equal my_hash.seek(:b), { c: 2 }
  end
end
