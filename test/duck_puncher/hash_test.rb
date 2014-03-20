require 'minitest/autorun'
require 'duck_puncher'

class HashTest < MiniTest::Unit::TestCase
  def test_seek
    my_hash = {a: 1, b: {c: 2}}
    assert_equal my_hash.seek(:a), 1
    assert_equal my_hash.seek(:b, :a), nil
    assert_equal my_hash.seek(:b, :c), 2
    assert_equal my_hash.seek(:b), {c: 2}
  end
end