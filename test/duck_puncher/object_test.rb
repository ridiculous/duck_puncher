require_relative '../test_helper'
DuckPuncher.punch! :Object

class ObjectTest < MiniTest::Test
  def test_clone!
    obj = Object.new
    cloned = obj.clone!
    assert_equal cloned.class, obj.class
    refute_equal cloned, obj
  end
end
