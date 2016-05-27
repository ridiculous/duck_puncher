require_relative '../../test_helper'

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
end
