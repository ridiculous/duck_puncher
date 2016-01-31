require_relative '../test_helper'

DuckPuncher.punch! :String

class StringTest < MiniTest::Test
  def test_pluralize
    assert_equal 'hour'.pluralize(1), 'hour'
    assert_equal 'hour'.pluralize(0), 'hours'
    assert_equal 'hour'.pluralize(2), 'hours'
  end

  def test_underscore
    assert_equal 'MiniTest'.underscore, 'mini_test'
    assert_equal 'MiniTestDoItToIt'.underscore, 'mini_test_do_it_to_it'
    assert_equal 'MiniTest::Helper'.underscore, 'mini_test/helper'
    assert_equal 'MiniTest::Helper::Expectations'.underscore, 'mini_test/helper/expectations'
    assert_equal 'mini_test.rb', 'mini_test.rb'.underscore
    assert_equal 'duck_puncher/json_storage', 'DuckPuncher::JSONStorage'.underscore
  end
end
