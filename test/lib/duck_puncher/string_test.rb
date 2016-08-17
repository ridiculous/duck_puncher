require_relative '../../test_helper'

DuckPuncher.punch! String

class StringTest < MiniTest::Test
  def test_pluralize
    assert_equal 'hour', 'hour'.pluralize(1)
    assert_equal 'hours', 'hour'.pluralize(0)
    assert_equal 'hours', 'hour'.pluralize(2)
  end

  def test_underscore
    assert_equal 'mini_test', 'MiniTest'.underscore
    assert_equal 'mini_test_do_it_to_it', 'MiniTestDoItToIt'.underscore
    assert_equal 'mini_test/helper', 'MiniTest::Helper'.underscore
    assert_equal 'mini_test/helper/expectations', 'MiniTest::Helper::Expectations'.underscore
    assert_equal 'mini_test.rb', 'mini_test.rb'.underscore
    assert_equal 'duck_puncher/json_storage', 'DuckPuncher::JSONStorage'.underscore
  end

  def test_to_boolean
    assert 'true'.to_boolean
    assert '1'.to_boolean
    assert 'y'.to_boolean
    assert 'on'.to_boolean
    assert 'yes'.to_boolean
    refute 'false'.to_boolean
    refute '0'.to_boolean
    refute 'no'.to_boolean
    refute 'off'.to_boolean
    refute ''.to_boolean
    refute 'asd'.to_boolean
  end

  def test_constantize
    assert_equal MiniTest, 'MiniTest'.constantize
    assert_equal MiniTest::Test, 'MiniTest::Test'.constantize
  end
end
