require_relative '../test_helper'

class StringTest < MiniTest::Test
  def test_pluralize
    assert_equal 'hour'.pluralize(1), 'hour'
    assert_equal 'hour'.pluralize(0), 'hours'
    assert_equal 'hour'.pluralize(2), 'hours'
  end
end
